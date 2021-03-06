package ru.novaris.idempiere.nms.ui.zk.openlayers;

import org.zkoss.openlayers.Openlayers;

import static org.compiere.model.SystemIDs.COLUMN_C_INVOICE_C_BPARTNER_ID;
import static org.zkoss.openlayers.util.Helper.pair;
import static org.zkoss.openlayers.util.Helper.toMap;

import java.io.IOException;
import java.net.URL;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.logging.Level;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.net.ssl.SSLContext;

import org.adempiere.base.IResourceFinder;
import org.adempiere.base.Service;
import org.adempiere.webui.component.Label;
import org.adempiere.webui.dashboard.DashboardPanel;
import org.adempiere.webui.editor.WSearchEditor;
import org.adempiere.webui.event.ValueChangeEvent;
import org.adempiere.webui.event.ValueChangeListener;
import org.adempiere.webui.panel.CustomForm;
import org.adempiere.webui.theme.ThemeManager;
import org.adempiere.webui.util.ServerPushTemplate;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.ssl.SSLContexts;
import org.compiere.model.MAsset;
import org.compiere.model.MBPartner;
import org.compiere.model.MBPartnerLocation;
import org.compiere.model.MLocation;
import org.compiere.model.MLookup;
import org.compiere.model.MLookupFactory;
import org.compiere.model.MSysConfig;
import org.compiere.model.MUser;
import org.compiere.util.CLogger;
import org.compiere.util.DisplayType;
import org.compiere.util.Env;
import org.compiere.util.Msg;
import org.osgeo.proj4j.CRSFactory;
import org.osgeo.proj4j.CoordinateReferenceSystem;
import org.osgeo.proj4j.CoordinateTransform;
import org.osgeo.proj4j.CoordinateTransformFactory;
import org.osgeo.proj4j.ProjCoordinate;
import org.zkoss.openlayers.base.Icon;
import org.zkoss.openlayers.base.LonLat;
import org.zkoss.openlayers.base.Pixel;
import org.zkoss.openlayers.base.Projection;
import org.zkoss.openlayers.base.Size;
import org.zkoss.openlayers.base.StyleMap;
import org.zkoss.openlayers.control.Attribution;
import org.zkoss.openlayers.control.Control;
import org.zkoss.openlayers.control.LayerSwitcher;
import org.zkoss.openlayers.control.MousePosition;
import org.zkoss.openlayers.control.Navigation;
import org.zkoss.openlayers.control.OverviewMap;
import org.zkoss.openlayers.control.PanZoom;
import org.zkoss.openlayers.control.SelectFeature;
import org.zkoss.openlayers.feature.Feature;
import org.zkoss.openlayers.geometry.Point;
import org.zkoss.openlayers.layer.Layer;
import org.zkoss.openlayers.layer.Markers;
import org.zkoss.openlayers.layer.OSM;
import org.zkoss.openlayers.layer.WMS;
import org.zkoss.openlayers.feature.Vector;
import org.zkoss.openlayers.marker.Marker;
import org.zkoss.zk.ui.Component;
import org.zkoss.zk.ui.Executions;
import org.zkoss.zk.ui.event.Event;
import org.zkoss.zk.ui.event.EventListener;
import org.zkoss.zk.ui.event.EventQueue;
import org.zkoss.zk.ui.event.EventQueues;
import org.zkoss.zul.Toolbar;

import ru.novaris.idempiere.nms.ui.zk.nominatim.JsonNominatimClient;
import ru.novaris.idempiere.nms.ui.zk.nominatim.model.Address;

/**
 * Dashboard with Google Map Google geocoding library:
 * http://code.google.com/p/foreignlangdb/
 * 
 * @author Multimage
 */
public class DPOpenlayersMap extends DashboardPanel implements ValueChangeListener, EventListener<Event> {
	/**
	 * 
	 */
	private static final long serialVersionUID = 2751124688941438793L;
	/**
		 * 
		 */
	public static CLogger logger = CLogger.getCLogger(DPOpenlayersMap.class);

	private CustomForm form = new CustomForm();

	private final String MODULE_MARKER;

	// private final String MODULE_ALERT_MARKER;

	// private final String MODULE_SERVICE_MARKER;

	// private static final String BUTTON_ON = "1";

	private final int AD_CLIENT_ID;

	private final static int ICON_ANCHOR_X = 28;

	private final static int ICON_ANCHOR_Y = 28;

	private final static double MIN_SPEED = 0.1;

	private final String MODULE_STOP;

	private final String MODULE_STOP_RED;

	// private static final long BUTTON_ALERT = 5;

	// private static final long BUTTON_SERVICE = 6;

	private Label bPartnerLabel = new Label();
	private WSearchEditor bPartnerSearch = null;
	private Label assetLabel = new Label();
	private WSearchEditor assetSearch = null;
	/*  */
	private static final int COLUMN_A_ASSET_A_ASSET_ID = 8070;

	// private static final int ZOOM_INIT = 12;

	private static final String MARKER_TYPE_BPARTNER = "BP";

	// private static final String MARKER_TYPE_ALERT = "ALR";

	// private static final String MARKER_TYPE_SERVICE = "SRV";

	private static final String MARKER_TYPE_ASSET = "AS";

	private static final String MARKER_TYPE_LOC_BPARTNER = "LB";

	private static final SimpleDateFormat DF = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	private final String MODULE_UNKNOWN;

	private final String NAVIGATION_EVENT_QUEUE = "NavigationEvent";

	private final StringBuffer SB_MARKER = new StringBuffer();

	private final String BPARTNER_MARKER;

	public final String NOMINATIM_BASE_URL;

	public final String NOMINATIM_EMAIL;

	private CoordinateTransform transform;

	private Markers layerBpMarker;

	private Markers layerBpUser;

	// private Address address;

	private StringBuffer sbLoc = new StringBuffer();

	private Timestamp lastModifyDate;

	private final DPOpenlayersMapModel OPENLAYERS_MAP_MODEL;

	private final int MIN_H = 450;

	private final int MIN_W = 200;

	private final String MODULE_MARKER_RED;

	private Date currentDate = new Date();

	private final static String SRC_PROJ_NAME = "EPSG:4326";

	private final static String DST_PROJ_NAME = "EPSG:3857";

	private static final Projection SRC_PROJ = new Projection(SRC_PROJ_NAME); // geographic

	private static final Projection DST_PROJ = new Projection(DST_PROJ_NAME); // mercator

	private final Pattern URL_PATTERN = Pattern.compile(
			"^(((http|https)?:\\/\\/)|~/|/)?([a-zA-Z]{1}([\\w\\-]+\\.)+([\\w]{2,5})(:([\\d]{1,5}))?)/?(\\w+\\.[\\w]{3,4})?(.*)?");

	private JsonNominatimClient nominatimClient;

	// private HashMap<Long, String> alertKeys = new HashMap<Long, String>();
	// private HashMap<Long, String> serviceKeys = new HashMap<Long, String>();

	private HashMap<String, Vector> markers = new HashMap<String, Vector>();
	private HashMap<String, Vector> markerNames = new HashMap<String, Vector>();
	private HashMap<String, Marker> userMarkers = new HashMap<String, Marker>();
	// private HashMap<String, Marker> alertMarkers = new HashMap<String, Marker>();
	// private HashMap<String, Marker> serviceMarkers = new HashMap<String,
	// Marker>();

	private static final Pixel OFFSET_12 = new Pixel(-12, -12);

	private static final Size SIZE_24 = new Size(24, 24);

	private static Icon BP_ICON;

	private Double minLat = null;
	private Double maxLat = null;
	private Double minLng = null;
	private Double maxLng = null;

	private org.zkoss.openlayers.layer.Vector layerObjectMarker;
	private org.zkoss.openlayers.layer.Vector layerObjectName;
	private org.zkoss.openlayers.layer.Vector layerBpName;
	private Layer layerGeozones;

	private Openlayers omap;

	public DPOpenlayersMap() {
		super();
		AD_CLIENT_ID = Env.getAD_Client_ID(Env.getCtx());
		BPARTNER_MARKER = "images/" + MSysConfig.getValue("GMAP_BPARTNER_MARKER", "BPartner24.png", AD_CLIENT_ID);
		MODULE_MARKER = "images/" + MSysConfig.getValue("GMAP_MODULE_MARKER", "navGreen", AD_CLIENT_ID);
		MODULE_MARKER_RED = "images/" + MSysConfig.getValue("GMAP_MODULE_MARKER_RED", "navRed", AD_CLIENT_ID);
		// MODULE_ALERT_MARKER = "images/" +
		// MSysConfig.getValue("GMAP_MODULE_ALERT_MARKER", "navAlert.png",
		// AD_CLIENT_ID);

		// MODULE_SERVICE_MARKER = "images/"
		// + MSysConfig.getValue("GMAP_MODULE_SERVICE_MARKER", "navService.png",
		// AD_CLIENT_ID);
		MODULE_STOP = "images/" + MSysConfig.getValue("GMAP_MODULE_STOP", "stopBlue.png", AD_CLIENT_ID);
		MODULE_STOP_RED = "images/" + MSysConfig.getValue("GMAP_MODULE_STOP_RED", "stopRed.png", AD_CLIENT_ID);
		MODULE_UNKNOWN = "images/" + MSysConfig.getValue("GMAP_MODULE_UNKNOWN", "navUnknown.png", AD_CLIENT_ID);
		NOMINATIM_BASE_URL = MSysConfig.getValue(
				"NOMINATIM_BASE_URL", "https://nominatim.novaris.ru/nominatim/",
				AD_CLIENT_ID);
		NOMINATIM_EMAIL = MSysConfig.getValue("NOMINATIM_EMAIL", "support@novaris.ru", AD_CLIENT_ID);
		BP_ICON = new Icon(
				Executions.getCurrent().getContextPath() + ThemeManager.getThemeResource(BPARTNER_MARKER),
				SIZE_24, OFFSET_12);
		OPENLAYERS_MAP_MODEL = new DPOpenlayersMapModel();
		currentDate.setTime(System.currentTimeMillis() - 3600 * 1000);

		initSearch();
		initNominatimClient();
		initOpenlayerMaps();

		addModules();
		addUserMarker();
		addBPartners();
		logger.severe("Масштаб карты: " + getZoom());
		omap.setCenter(getCenter(), getZoom());
		omap.zoomToMaxExtent();
		// ZoomCenter zoomCenter = getZoomCenter();
		//omap.setCenter(zoomCenter.getCenter(), zoomCenter.getZoom());
	}

	/**
	 *
	 */

	private void initTransform() {
		CRSFactory factory = new CRSFactory();
		CoordinateReferenceSystem srcCrs = factory.createFromName(SRC_PROJ_NAME); // Use "EPSG:3857" here instead of 900913.
		CoordinateReferenceSystem destCrs = factory.createFromName(DST_PROJ_NAME); // Use "EPSG:4326 here.
		transform = new CoordinateTransformFactory().createTransform(srcCrs, destCrs);
	}

	private void initSearch() {
		// BPartner
		int AD_Column_ID = COLUMN_C_INVOICE_C_BPARTNER_ID; // C_Invoice.C_BPartner_ID
		MLookup lookup = MLookupFactory.get(Env.getCtx(), form.getWindowNo(), 0, AD_Column_ID, DisplayType.Search);
		bPartnerSearch = new WSearchEditor("C_BPartner_ID", false, false, true, lookup);
		bPartnerSearch.addValueChangeListener(this);
		// Asset
		AD_Column_ID = COLUMN_A_ASSET_A_ASSET_ID; // A_Asset.A_Asset_ID
		lookup = MLookupFactory.get(Env.getCtx(), form.getWindowNo(), 0, AD_Column_ID, DisplayType.Search);
		assetSearch = new WSearchEditor("A_Asset_ID", false, false, true, lookup);
		assetSearch.addValueChangeListener(this);

		bPartnerLabel.setText(Msg.translate(Env.getCtx(), "C_BPartner_ID"));
		bPartnerLabel.setStyle("margin-right:5px; margin-left:10px;");

		assetLabel.setText("Объект");
		assetLabel.setStyle("margin-right:5px; margin-left:10px;");

		Toolbar panel = new Toolbar();
		this.appendChild(panel);
		panel.appendChild(bPartnerLabel);
		panel.appendChild(bPartnerSearch.getComponent());

		panel.appendChild(assetLabel);
		panel.appendChild(assetSearch.getComponent());
	}

	private void initNominatimClient() {
		try {
			Integer port = 80;
			String protocol = "http";
			logger.severe("Подключение к серверу Nominatim: " + NOMINATIM_BASE_URL);
			// final SchemeRegistry registry = new SchemeRegistry();
			Matcher m = URL_PATTERN.matcher(NOMINATIM_BASE_URL);
			if (m.matches()) {
				if (m.group(3) == null || m.group(3).isEmpty()) {
					protocol = "http";
				} else if (m.group(3).equalsIgnoreCase("https")) {
					protocol = "https";
				}
				if (m.group(8) == null || m.group(8).isEmpty()) {
					if (protocol.equals("https")) {
						port = 443;
					} else {
						port = 80;
					}
				} else {
					port = Integer.valueOf(m.group(8));
				}
				CloseableHttpClient httpclient;
				if (protocol.equals("https")) {
					logger.severe("Инициализация SSL HTTP порт: " + port);
					SSLContext sslcontext = SSLContexts.createDefault();
					SSLConnectionSocketFactory sslsf = new SSLConnectionSocketFactory(sslcontext);
					httpclient = HttpClients.custom().setSSLSocketFactory(sslsf).build();
				} else {
					logger.severe("Инициализация HTTP порт: " + port);
					httpclient = HttpClients.createDefault();
				}
				nominatimClient = new JsonNominatimClient(NOMINATIM_BASE_URL, httpclient, NOMINATIM_EMAIL);
			} else {
				logger.severe("Ошибка инициализации. Некорректный Nominatim URL: " + NOMINATIM_BASE_URL);
			}
		} catch (Exception e) {
			logger.severe("Ошибка инициализации клиента запроса к Nominantum: " + e.getMessage());
			e.printStackTrace();
		}
	}

	private void initOpenlayerMaps() {
		List<IResourceFinder> f = Service.locator().list(IResourceFinder.class).getServices();
		URL url = null;
		for (IResourceFinder finder : f) {
			url = finder.getResource("/zul/omap_mini.zul");
		}
		Component component = Executions.createComponents(url.toString(), this, null);
		omap = (Openlayers) component.getFellow("map");
		omap.setStyle(
				"height: " + MIN_H
						+ "px;  width: "
						+ MIN_W
						+ "px; min-height: "
						+ MIN_H
						+ "px;  min-width: "
						+ MIN_W
						+ "px;");
		omap.setId("OMAP");
		omap.setOptions(
				toMap(
						pair("projection", DST_PROJ),
						pair("units", "m"),
						pair("controls", Collections.EMPTY_LIST)));
		// omap.addEventListener("onMapClick", DPOpenlayersMap.this);

		omap.addControl(new LayerSwitcher());
		omap.addControl(new Navigation());
		omap.addControl(new PanZoom());
		omap.addControl(new Attribution());
		omap.addControl(new OverviewMap(toMap(pair("maximized", false))));
		omap.addControl(new MousePosition(toMap(pair("separator", ";"))));
		Control selectFeature = new SelectFeature(layerObjectMarker);
		omap.addControl(selectFeature);
		selectFeature.activate();

		layerGeozones = new org.zkoss.openlayers.layer.Vector("Геозоны");
		// omap.addControl(new EditingToolbar(layerGeozones)); //-- ошибка!!! при
		// масштабировании!! не находит UUID

		// omaps.addLayer(new VirtualEarth("Shaded", toMap(pair("type",
		// VirtualEarth.Type.SHADED))));
		// omaps.addLayer(new VirtualEarth("Hybrid", toMap(pair("type",
		// VirtualEarth.Type.HYBRID))));
		// omaps.addLayer(new VirtualEarth("Aerial", toMap(pair("type",
		// VirtualEarth.Type.AERIAL))));
		// omaps.addLayer(new GoogleV3("Google Streets", toMap(pair("type",
		// GoogleV3.Type.ROADMAP))));
		// omaps.addLayer(new GoogleV3("Google Satellite", toMap(pair("numZoomLevels",
		// 20))));
		// omaps.addLayer(new GoogleV3("Google Hybrid", toMap(pair("type",
		// GoogleV3.Type.HYBRID), pair("numZoomLevels", 20))));
		// omaps.addLayer(new GoogleV3("Google Physical", toMap(pair("type",
		// GoogleV3.Type.SATELLITE), pair("numZoomLevels", 22))));
		// WMS
		// Create a WMS layer as base layer
		Layer layerWms = new WMS(
				"Карта локальная", "https://cloud.novaris.ru:8181/geoserver/novoscan/wms",
				toMap(
						pair("layers", "novoscan:novoscan"),
						pair("format", "image/png"),
						pair("isBaseLayer", true)));
		Layer layerOsm = new OSM("Карта OSM");

		omap.addLayer(layerWms);
		omap.addLayer(layerOsm);

		layerObjectMarker = new org.zkoss.openlayers.layer.Vector(
				"Объект", toMap(
						pair(
								"styleMap", new StyleMap(
										toMap(
												pair(
														"default",
														toMap(
																pair("strokeColor", "#00FF00"),
																pair("strokeOpacity", 1), pair("strokeWidth", 1),
																pair("fillColor", "#FF5500"), pair("fillOpacity", 0.5),
																pair("pointRadius", 0.1),
																// pair("pointerEvents", "visiblePainted"),
																pair("externalGraphic", "${image}"),
																pair("graphicHeight", "${imageHeight}"),
																pair("graphicWidth", "${imageWidth}"),
																pair("graphicYOffset", "${imageHeightOffset}"),
																pair("graphicXOffset", "${imageWidthOffset}"),
																pair("graphicTitle", "this is a test tooltip")))))),
						pair("renderers", new Object[] { "SVG", "VML", "Canvas" })));

		layerBpName = new org.zkoss.openlayers.layer.Vector(
				"Имя БП",
				toMap(
						pair(
								"styleMap",
								new StyleMap(
										toMap(
												pair(
														"default",
														toMap(
																pair("strokeColor", "#00FF00"),
																pair("strokeOpacity", 1), pair("strokeWidth", 1),
																pair("fillColor", "#FF5500"), pair("fillOpacity", 0.5),
																pair("pointRadius", 0.1)
																// ,pair("pointerEvents", "visiblePainted")
																, pair("label", "${name}\n"),
																pair("fontColor", "${favColor}"),
																pair("fontSize", "10px"),
																pair("fontFamily", "Courier New, monospace"),
																pair("fontWeight", "bold"),
																pair("labelAlign", "${align}"),
																pair("labelXOffset", "${xOffset}"),
																pair("labelYOffset", "${yOffset}")))))),
						pair("renderers", new Object[] { "SVG", "VML", "Canvas" })));

		layerObjectName = new org.zkoss.openlayers.layer.Vector(
				"Имя объекта", toMap(
						pair(
								"styleMap", new StyleMap(
										toMap(
												pair(
														"default",
														toMap(
																pair("strokeColor", "#00FF00"),
																pair("strokeOpacity", 1), pair("strokeWidth", 1),
																pair("fillColor", "#FF5500"), pair("fillOpacity", 0.5),
																pair("pointRadius", 0.1),
																pair("label", "${name}\n"),
																pair("fontColor", "${favColor}"),
																pair("fontSize", "10px"),
																pair("fontFamily", "Courier New, monospace"),
																pair("fontWeight", "bold"),
																pair("labelAlign", "${align}"),
																pair("labelXOffset", "${xOffset}"),
																pair("labelYOffset", "${yOffset}")))))),
						pair("renderers", new Object[] { "SVG", "VML", "Canvas" })));

		layerBpMarker = new Markers("БП");
		layerBpUser = new Markers("Пользователи");

		omap.addLayer(layerObjectName);
		omap.addLayer(layerObjectMarker);

		omap.addLayer(layerBpName);
		omap.addLayer(layerBpMarker);
		omap.addLayer(layerBpUser);

		omap.addLayer(layerGeozones);

		initTransform();
		logger.severe(
				"Загрузка карты для пользователя: " + Env.getAD_User_ID(Env.getCtx())
						+ " с ролью: "
						+ Env.getAD_Role_ID(Env.getCtx()));
	}

	private LonLat getCenter() {
		LonLat lonLat = getLonLat(82.88321, 55.044046);
		if (minLat != null) {
			Double ctrLng = (maxLng + minLng) / 2.0;
			Double ctrLat = (maxLat + minLat) / 2.0;
			lonLat = getLonLat(ctrLng, ctrLat);
		}
		logger.severe("Центр : " + lonLat.toString());
		return lonLat;
	}

	private int getZoom() {
		Double meterPixel = Math.sqrt(Math.pow((maxLng - minLng), 2) + Math.pow((maxLat - minLat), 2)) / (2 * MIN_H);
		int zoom = 11;
		if (meterPixel <= 0.596) {
			zoom = 18;
		} else if (meterPixel <= 1.193) {
			zoom = 17;
		} else if (meterPixel <= 2.387) {
			zoom = 16;
		} else if (meterPixel <= 4.773) {
			return 15;
		} else if (meterPixel <= 9.547) {
			zoom = 14;
		} else if (meterPixel <= 19.093) {
			return 13;
		} else if (meterPixel <= 38.187) {
			zoom = 12;
		} else if (meterPixel <= 76.373) {
			zoom = 11;
		} else if (meterPixel <= 152.746) {
			return 10;
		} else if (meterPixel <= 305.492) {
			zoom = 9;
		} else if (meterPixel <= 610.984) {
			zoom = 8;
		} else if (meterPixel <= 1222) {
			zoom = 7;
		} else if (meterPixel <= 2444) {
			zoom = 6;
		} else if (meterPixel <= 4888) {
			zoom = 5;
		} else if (meterPixel <= 9776) {
			zoom = 4;
		} else if (meterPixel <= 19551) {
			zoom = 3;
		} else if (meterPixel <= 39103) {
			zoom = 2;
		} else if (meterPixel <= 78206) {
			zoom = 1;
		} else if (meterPixel <= 156412) {
			zoom = 0;
		}
		return zoom;
	}

	private void addBPartners() {
		for (int bPartner : OPENLAYERS_MAP_MODEL.getBPartner()) {
			addBPartnerMarker(MBPartner.get(Env.getCtx(), bPartner));
		}
	}

	/**
	 * After Map init show only user location marker
	 */
	private void addUserMarker() {
		int locationId = 0;
		MUser user = MUser.get(Env.getCtx(), Env.getAD_User_ID(Env.getCtx()));
		locationId = user.getC_BPartner_Location_ID();
		if (locationId == 0)
			return;
		try {
			MBPartnerLocation bpl = new MBPartnerLocation(Env.getCtx(), locationId, null);
			if (bpl.getC_Location_ID() <= 0)
				return;
			MLocation location = MLocation.get(Env.getCtx(), bpl.getC_Location_ID(), null);
			SB_MARKER.setLength(0);
			SB_MARKER.append(location.getAddress1()).append(", ").append(location.getCity());
			Address address = nominatimClient.search(SB_MARKER.toString());
			// Add marker
			Marker marker = getUserMarker(bpl, address);

			// new Marker(Msg.translate(Env.getCtx(), bpl.getName()), address.getLatitude(),
			// address.getLongitude());
			logger.severe("Add marker: Lat=" + address.getLatitude() + " Lon=" + address.getLongitude());
			String id = getMarkerId(bpl);
			if (marker != null) {
				if (!userMarkers.containsKey(id)) {
					userMarkers.put(id, marker);
					layerBpUser.addMarker(marker);
				} else {
					if (!userMarkers.get(id).equals(marker)) {
						layerBpUser.removeMarker(userMarkers.get(id));
						layerBpUser.addMarker(marker);
					}
				}
			}
		} catch (Exception e) {
			logger.severe(e.getMessage());
		}
	}

	private void addBPartnerMarker(MBPartner partner) {
		if (partner == null) {
			logger.severe("Business Partner not exists");
			return;
		}
		MBPartnerLocation locations[] = partner.getLocations(false);
		for (int i = 0; i < locations.length; i++) {
			addMarkerLocation(locations[i].getLocation(false), partner);
		}
	}

	private void addMarkerLocation(MLocation location, Object object) {
		LonLat lnglat;
		SB_MARKER.setLength(0);
		if (location == null || object == null) {
			return;
		}
		try {
			lnglat = locationToPoint(location);
			if (lnglat == null) {
				logger.severe("Failed to geocode location [" + location + "]");
				return;
			}

			if (object instanceof MBPartner) {
				MBPartner partner = (MBPartner) object;
				Point point = new Point(lnglat.getLon(), lnglat.getLat());
				Feature feature = new org.zkoss.openlayers.feature.Vector(
						point,
						toMap(pair("name", partner.getName()), pair("favColor", "blue"), pair("align", "cb")));
				layerBpName.addFeature(feature);
				/*
				 * SB_MARKER.append("<b>").append(name).append("</b><br>")
				 * .append(Msg.translate(Env.getCtx(), MBPartner.COLUMNNAME_TotalOpenBalance))
				 * .append(partner.getTotalOpenBalance()).append(getCurrencyCode(partner)).
				 * append("<br>")
				 * .append("<br><i>").append(location.getAddress1()).append(", ").append(
				 * location.getCity()) .append("</i>");
				 */
			}
			Marker marker = new Marker(lnglat, (Icon) BP_ICON.clone());
			layerBpMarker.addMarker(marker);
		} catch (IOException e) {
			logger.severe(e.getLocalizedMessage());
		}

	}

	private LonLat locationToPoint(MLocation location) throws IOException {
		if (location == null)
			return null;
		sbLoc.setLength(0);
		try {
			sbLoc.append(location.getAddress1());
			if (location.getCity() != null && location.getCity().length() > 0)
				sbLoc.append(", ").append(location.getCity());
			Address address = nominatimClient.search(sbLoc.toString());
			LonLat lnglat = null;
			lnglat = getLonLat(address);
			if (lnglat != null) {
				return lnglat;
			}
		} catch (Exception e) {
			logger.severe("Error get locations to point: " + e.getLocalizedMessage());
		}
		return null;
	}

	private Marker getUserMarker(MBPartnerLocation bpl, Address address) {
		Marker marker = new Marker(getLonLat(address), (Icon) BP_ICON.clone());
		return marker;
	}

	private LonLat getLonLat(Address address) {
		return (getLonLat(address.getLongitude(), address.getLatitude()));
	}

	@Override
	public void refresh(ServerPushTemplate template) {
		template.executeAsync(this);
	}

	@Override
	public void updateUI() {
		EventQueue<Event> queue = EventQueues.lookup(this.NAVIGATION_EVENT_QUEUE, true);
		Event event = new Event(this.NAVIGATION_EVENT_QUEUE, null, lastModifyDate);
		currentDate.setTime(System.currentTimeMillis() - 3600 * 1000);
		updateMarkers();
		// addModulesRequest();
		queue.publish(event);
	}

	private void updateMarkers() {
		List<ModuleNavInfo> infoModules = OPENLAYERS_MAP_MODEL.getNavInfoModules();
		logger.severe("Обновление навигационных данных: " + infoModules.size());
		if (infoModules != null && infoModules.size() > 0) {
			for (ModuleNavInfo navModuleLastInfo : infoModules) {
				updateMarker(navModuleLastInfo);
			}
			lastModifyDate = OPENLAYERS_MAP_MODEL.getLastDate();
		}
	}

	private void updateMarker(ModuleNavInfo navInfo) {
		String id = getMarkerId(navInfo);
		Vector marker = getMarker(id);
		Vector markerName = getMarkerName(id);
		Point point = getPoint(navInfo.getNavLongitude(), navInfo.getNavLatitude());
		if (marker == null) {
			marker = getNavMarker(navInfo, point);
			markerName = getNavMarkerName(navInfo, point);
		}
		addNavMarker(marker, markerName, id);
	}

	private void addNavMarker(Vector marker, Vector markerName, String id) {
		if (marker != null) {
			if (!markers.containsKey(id)) {
				markers.put(id, marker);
				markerNames.put(id, markerName);
				layerObjectMarker.addFeature(marker);
				layerObjectName.addFeature(markerName);
			} else {
				if (!markers.get(id).getData().get("lastDate").equals(marker.getData().get("lastDate"))) {
					logger.severe("Обновление данных о маркере: " + id);
					layerObjectMarker.removeFeature(markers.get(id));
					layerObjectName.removeFeature(markerNames.get(id));
					//
					layerObjectMarker.addFeature(marker);
					layerObjectName.addFeature(markerName);
				}
			}
		}
	}

	private Vector getNavMarkerName(ModuleNavInfo navInfo, Point point) {
		return new Vector(
				point,
				toMap(pair("name", navInfo.getName()), pair("favColor", "green"), pair("align", "cb")));
	}

	private void addModules() {
		for (ModuleNavInfo navInfo : OPENLAYERS_MAP_MODEL.getNavModules()) {
			logger.fine("Добавляем на карту объект: " + navInfo.getName());
			addModuleMarker(navInfo, getMarkerId(navInfo));
		}
	}

	private Vector getMarker(String id) {
		if (markers.containsKey(id))
			return markers.get(id);
		return null;
	}

	private Vector getMarkerName(String id) {
		if (markerNames.containsKey(id))
			return markerNames.get(id);
		return null;
	}

	private String getMarkerId(Object object) {
		if (object instanceof ModuleNavInfo) {
			return MARKER_TYPE_ASSET + String.valueOf(((ModuleNavInfo) object).getaAsset());
		} else if (object instanceof MBPartnerLocation) {
			return MARKER_TYPE_BPARTNER + String.valueOf(((MBPartnerLocation) object).getC_BPartner_ID());
		} else if (object instanceof MAsset) {
			return MARKER_TYPE_ASSET + String.valueOf(((MAsset) object).getA_Asset_ID());
		} else if (object instanceof MBPartner) {
			return MARKER_TYPE_LOC_BPARTNER + String.valueOf(((MBPartner) object).getC_BPartner_ID());
		} else {
			return "None";
		}
	}

	private void addModuleMarker(ModuleNavInfo navInfo, String id) {

		if (navInfo == null)
			return;
		try {
			if ((minLat == null) || (navInfo.getNavLatitude() < minLat)) {
				minLat = navInfo.getNavLatitude();
			}

			if ((maxLat == null) || (navInfo.getNavLatitude() > maxLat)) {
				maxLat = navInfo.getNavLatitude();
			}

			if ((minLng == null) || (navInfo.getNavLongitude() < minLng)) {
				minLng = navInfo.getNavLongitude();
			}

			if ((maxLng == null) || (navInfo.getNavLongitude() > maxLng)) {
				maxLng = navInfo.getNavLongitude();
			}

			Point point = getPoint(navInfo.getNavLongitude(), navInfo.getNavLatitude());
			addNavMarker(getNavMarker(navInfo, point), getNavMarkerName(navInfo, point), id);
		} catch (Exception e) {
			logger.severe("Ошибка добавление маркера : " + e.getMessage());
		}

	}

	@Override
	public void onEvent(Event e) {
		logger.severe("Event on object : " + e.getName());
		// if (e instanceof ) {
		// MapMouseEvent mapEvent = (MapMouseEvent) e;
		// logger.severe("Event on object : " + e.getName());
		/*
		 * Markers markerClick = mapEvent.getGmarker(); if (markerClick != null) { if
		 * (markerClick.isOpen()) { markerClick.setOpen(false);
		 * markerClick.setFocus(false); } else { markerClick.setOpen(true);
		 * markerClick.setFocus(true); // omaps.setCenter(markerClick.getLat(),
		 * markerClick.getLng()); } }
		 */
		// }
	}

	@Override
	public boolean isPooling() {
		return true;
	}

	private Vector getNavMarker(ModuleNavInfo navInfo, Point point) {
		Vector marker = new Vector(
				point,
				toMap(
						pair("image", getResourceName(navInfo)), pair("imageWidth", ICON_ANCHOR_X * 2),
						pair("imageHeight", ICON_ANCHOR_Y * 2), pair("imageWidthOffset", -ICON_ANCHOR_X),
						pair("imageHeightOffset", -ICON_ANCHOR_Y),
						pair("lastDate", DF.format(navInfo.getNavDatetime()))));
		return marker;
	}

	private String getResourceName(ModuleNavInfo navInfo) {
		// Навигационная информация
		String resourceName = MODULE_UNKNOWN;
		if (navInfo.getNavDatetime().before(currentDate)) {
			if (navInfo.getNavSpeed() < MIN_SPEED) {
				resourceName = ThemeManager.getThemeResource(MODULE_STOP_RED);
			} else {
				resourceName = getIconFile(MODULE_MARKER_RED, navInfo.getNavСourse());
			}
		} else {
			if (navInfo.getNavSpeed() < MIN_SPEED) {
				resourceName = ThemeManager.getThemeResource(MODULE_STOP);
			} else {
				resourceName = getIconFile(MODULE_MARKER, navInfo.getNavСourse());
			}
		}
		return Executions.getCurrent().getContextPath() + resourceName;
	}

	private String getIconFile(String baseName, double navСourse) {
		return ThemeManager.getThemeResource(baseName + "-" + (int) navСourse + ".png");
	}

	private LonLat getLonLat(Double lon, Double lat) {
		if (SRC_PROJ.equals(omap.getProjection())) {
			return new LonLat(lon, lat);
		}
		ProjCoordinate srcCoord = new ProjCoordinate(lon, lat);
		ProjCoordinate destCoord = new ProjCoordinate();
		transform.transform(srcCoord, destCoord);
		return new LonLat(destCoord.x, destCoord.y);
	}

	private Point getPoint(Double lon, Double lat) {
		if (SRC_PROJ.equals(omap.getProjection())) {
			return new Point(lon, lat);
		}
		ProjCoordinate srcCoord = new ProjCoordinate(lon, lat);
		ProjCoordinate destCoord = new ProjCoordinate();
		transform.transform(srcCoord, destCoord);
		return new Point(destCoord.x, destCoord.y);
	}

	@Override
	public void valueChange(ValueChangeEvent e) {
		String name = e.getPropertyName();
		Object value = e.getNewValue();
		if (logger.isLoggable(Level.CONFIG))
			logger.config(name + "=" + value);
		if (value == null)
			return;
		if (name.equals("C_BPartner_ID")) {
			bPartnerSearch.setValue(value);
			int m_C_BPartner_ID = ((Integer) value).intValue();
			if (m_C_BPartner_ID > 0) {
				//MBPartner partner = new MBPartner(Env.getCtx(), m_C_BPartner_ID, null);
				/* TODO Show marker */
				// showMarker(partner);
			}
		} else if (name.equals("A_Asset_ID")) {
			assetSearch.setValue(value);
			int m_A_Asset_ID = ((Integer) value).intValue();
			logger.fine("Ищем A_Asset_ID=" + m_A_Asset_ID);
			if (m_A_Asset_ID > 0) {
				//MAsset asset = new MAsset(Env.getCtx(), m_A_Asset_ID, null);
				/* TODO Show marker */
				// showMarker(asset);
			}
		}
	}

}
