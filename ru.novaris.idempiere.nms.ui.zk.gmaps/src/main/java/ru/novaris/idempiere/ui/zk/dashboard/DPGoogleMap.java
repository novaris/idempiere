package ru.novaris.idempiere.ui.zk.dashboard;

import static org.compiere.model.SystemIDs.COLUMN_C_INVOICE_C_BPARTNER_ID;

import java.io.IOException;
import java.net.URL;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
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
import org.compiere.model.MAssetGroup;
import org.compiere.model.MBPartner;
import org.compiere.model.MBPartnerLocation;
import org.compiere.model.MClientInfo;
import org.compiere.model.MLocation;
import org.compiere.model.MLookup;
import org.compiere.model.MLookupFactory;
import org.compiere.model.MSysConfig;
import org.compiere.model.MUser;
import org.compiere.util.CLogger;
import org.compiere.util.DisplayType;
import org.compiere.util.Env;
import org.compiere.util.Msg;
import org.zkoss.gmaps.Gmaps;
import org.zkoss.gmaps.Gmarker;
import org.zkoss.gmaps.LatLng;
import org.zkoss.gmaps.event.MapMouseEvent;
import org.zkoss.zk.ui.Component;
import org.zkoss.zk.ui.Executions;
import org.zkoss.zk.ui.event.Event;
import org.zkoss.zk.ui.event.EventListener;
import org.zkoss.zk.ui.event.EventQueue;
import org.zkoss.zk.ui.event.EventQueues;
import org.zkoss.zk.ui.event.Events;
import org.zkoss.zul.Toolbar;

import ru.novaris.idempiere.ui.zk.nominatim.JsonNominatimClient;
import ru.novaris.idempiere.ui.zk.nominatim.model.Address;

/**
 * Dashboard with Google Map Google geocoding library:
 * http://code.google.com/p/foreignlangdb/
 * 
 * @author Multimage
 */

public class DPGoogleMap extends DashboardPanel implements ValueChangeListener, EventListener<Event> {

	/** Logger */
	public static CLogger logger = CLogger.getCLogger(DPGoogleMap.class);

	private CustomForm form = new CustomForm();

	private static final long serialVersionUID = -4852479125712952883L;

	private final String MODULE_MARKER;

	private final String MODULE_ALERT_MARKER;

	private final String MODULE_SERVICE_MARKER;

	private static final String BUTTON_ON = "1";

	private final int AD_CLIENT_ID;

	private final static int ICON_ANCHOR_X = 28;

	private final static int ICON_ANCHOR_Y = 28;

	private final static double MIN_SPEED = 0.1;

	private final String MODULE_STOP;

	private final String MODULE_STOP_RED;

	private static final long BUTTON_ALERT = 5;

	private static final long BUTTON_SERVICE = 6;

	private Gmaps gmaps;

	//
	private HashMap<String, Gmarker> markers = new HashMap<String, Gmarker>();
	private HashMap<String, Gmarker> alertMarkers = new HashMap<String, Gmarker>();
	private HashMap<String, Gmarker> serviceMarkers = new HashMap<String, Gmarker>();
	//
	private HashMap<String, ModuleNavInfo> currRequests = new HashMap<String, ModuleNavInfo>();
	private HashMap<String, ModuleNavInfo> lastRequests = new HashMap<String, ModuleNavInfo>();
	private HashMap<Long, String> alertKeys = new HashMap<Long, String>();
	private HashMap<Long, String> serviceKeys = new HashMap<Long, String>();

	public HashMap<String, ModuleNavInfo> getLastRequests() {
		return lastRequests;
	}

	public void setLastRequests(HashMap<String, ModuleNavInfo> lastRequests) {
		this.lastRequests.clear();
		this.lastRequests.putAll(lastRequests);
	}

	private Label bPartnerLabel = new Label();
	private WSearchEditor bPartnerSearch = null;
	private Label assetLabel = new Label();
	private WSearchEditor assetSearch = null;
	/*  */
	private static final int COLUMN_A_ASSET_A_ASSET_ID = 8070;
	private static final int ZOOM_INIT = 12;
	private static final String MARKER_TYPE_BPARTNER = "BP";
	private static final String MARKER_TYPE_ALERT = "ALR";
	private static final String MARKER_TYPE_SERVICE = "SRV";
	private static final String MARKER_TYPE_ASSET = "AS";
	private static final String MARKER_TYPE_LOC_BPARTNER = "LB";
	private static final SimpleDateFormat DF = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	private final String MODULE_UNKNOWN;

	private final String NAVIGATION_EVENT_QUEUE = "NavigationEvent";

	public static int getZoomInit() {
		return ZOOM_INIT;
	}

	private final StringBuffer SB_MARKER = new StringBuffer();

	private final String BPARTNER_MARKER;

	public final String NOMINATIM_BASE_URL;

	public final String NOMINATIM_EMAIL;

	private Address address;

	private StringBuffer sbLoc = new StringBuffer();

	private Timestamp lastModifyDate;

	private final DPGoogleMapModel GOOGLE_MAP_MODEL;

	private final String MODULE_MARKER_RED;

	private Date currentDate = new Date();

	private final Pattern URL_PATTERN = Pattern.compile(
			"^(((http|https)?:\\/\\/)|~/|/)?([a-zA-Z]{1}([\\w\\-]+\\.)+([\\w]{2,5})(:([\\d]{1,5}))?)/?(\\w+\\.[\\w]{3,4})?(.*)?");

	private JsonNominatimClient nominatimClient;

	/**
	 * 
	 */
	public DPGoogleMap() {
		super();
		AD_CLIENT_ID = Env.getAD_Client_ID(Env.getCtx());

		BPARTNER_MARKER = "images/" + MSysConfig.getValue("GMAP_BPARTNER_MARKER", "BPartner24.png", AD_CLIENT_ID);

		MODULE_MARKER = "images/" + MSysConfig.getValue("GMAP_MODULE_MARKER", "navGreen", AD_CLIENT_ID);

		MODULE_MARKER_RED = "images/" + MSysConfig.getValue("GMAP_MODULE_MARKER_RED", "navRed", AD_CLIENT_ID);

		MODULE_ALERT_MARKER = "images/" + MSysConfig.getValue("GMAP_MODULE_ALERT_MARKER", "navAlert.png", AD_CLIENT_ID);

		MODULE_SERVICE_MARKER = "images/"
				+ MSysConfig.getValue("GMAP_MODULE_SERVICE_MARKER", "navService.png", AD_CLIENT_ID);

		MODULE_STOP = "images/" + MSysConfig.getValue("GMAP_MODULE_STOP", "stopBlue.png", AD_CLIENT_ID);

		MODULE_STOP_RED = "images/" + MSysConfig.getValue("GMAP_MODULE_STOP_RED", "stopRed.png", AD_CLIENT_ID);

		MODULE_UNKNOWN = "images/" + MSysConfig.getValue("GMAP_MODULE_UNKNOWN", "navUnknown.png", AD_CLIENT_ID);

		NOMINATIM_BASE_URL = MSysConfig.getValue("NOMINATIM_BASE_URL", "https://nominatim.novaris.ru/nominatim/",
				AD_CLIENT_ID);

		NOMINATIM_EMAIL = MSysConfig.getValue("NOMINATIM_EMAIL", "support@novaris.ru", AD_CLIENT_ID);

		GOOGLE_MAP_MODEL = new DPGoogleMapModel();

		currentDate.setTime(System.currentTimeMillis() - 3600 * 1000);
		initSearch();
		initNominatimClient();
		initGoogleMaps();

		addModules();
		addModulesRequest();
		addUserMarker();
		addBPartners();

		scaleMap(gmaps);
		// gmaps.setZoom(ZOOM_INIT);
	}

	private void initGoogleMaps() {
		List<IResourceFinder> f = Service.locator().list(IResourceFinder.class).getServices();
		URL url = null;
		for (IResourceFinder finder : f) {
			url = finder.getResource("/zul/gmap_mini.zul");
		}
		Component component = Executions.createComponents(url.toString(), this, null);
		gmaps = (Gmaps) component.getFellow("map");
		gmaps.addEventListener("onMapClick", DPGoogleMap.this);
		gmaps.setStyle("min-height:450px;");
		gmaps.setProtocol("https");
		gmaps.setShowScaleCtrl(true);
		logger.fine("Загрузка карты для пользователя: " + Env.getAD_User_ID(Env.getCtx()) + " с ролью: "
				+ Env.getAD_Role_ID(Env.getCtx()));
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
		addModulesRequest();
		queue.publish(event);
	}

	private void updateMarkers() {
		List<ModuleNavInfo> infoModules = GOOGLE_MAP_MODEL.getNavInfoModules();
		if (infoModules != null && infoModules.size() > 0) {
			for (ModuleNavInfo navModuleLastInfo : infoModules) {
				updateMarker(navModuleLastInfo);
			}
			lastModifyDate = GOOGLE_MAP_MODEL.getLastDate();
		}
	}

	private void updateMarker(ModuleNavInfo navInfo) {
		String id = getMarkerId(navInfo);
		Gmarker marker = getMarker(id);
		if (marker == null) {
			marker = new Gmarker();
		}
		getNavMarker(marker, navInfo);
		if (getAlertButton(navInfo).equals(BUTTON_ON)) {
			addMarkerAlert(navInfo);
			marker.setOpen(true);
		} else {
			removeMarkerAlert(navInfo);
		}
		if (getServiceButton(navInfo).equals(BUTTON_ON)) {
			addMarkerService(navInfo);
		} else {
			removeMarkerService(navInfo);
		}
		addMarker(marker, id);
	}

	private void removeMarkerService(ModuleNavInfo navInfo) {
		String id = getServiceMarkerId(navInfo.getNmModule());
		if (serviceMarkers.containsKey(id)) {
			gmaps.removeChild(serviceMarkers.get(id));
			serviceMarkers.remove(id);
		}
	}

	private void addMarkerService(ModuleNavInfo navInfo) {
		String id = getServiceMarkerId(navInfo.getNmModule());
		Gmarker marker;
		if (!serviceMarkers.containsKey(id)) {
			marker = new Gmarker();
			marker.setLat(navInfo.getNavLatitude());
			marker.setLng(navInfo.getNavLongitude());
			marker.setIconImage(ThemeManager.getThemeResource(MODULE_SERVICE_MARKER));
			marker.setIconAnchorX(ICON_ANCHOR_X);
			marker.setIconAnchorY(ICON_ANCHOR_Y);
			serviceMarkers.put(id, marker);
			marker.setId(id);
			marker.setParent(gmaps);
		} else {
			marker = serviceMarkers.get(id);
			marker.setLat(navInfo.getNavLatitude());
			marker.setLng(navInfo.getNavLongitude());
		}
	}

	private String getServiceMarkerId(long nmModule) {
		return MARKER_TYPE_SERVICE + nmModule;
	}

	private String getServiceAlertId(long nmModule) {
		return MARKER_TYPE_ALERT + nmModule;
	}

	private void removeMarkerAlert(ModuleNavInfo navInfo) {
		String id = getServiceAlertId(navInfo.getNmModule());
		if (alertMarkers.containsKey(id)) {
			gmaps.removeChild(alertMarkers.get(id));
			alertMarkers.remove(id);
		}
	}

	private void addMarkerAlert(ModuleNavInfo navInfo) {
		String id = getServiceAlertId(navInfo.getNmModule());
		Gmarker marker;
		if (!alertMarkers.containsKey(id)) {
			marker = new Gmarker();
			marker.setLat(navInfo.getNavLatitude());
			marker.setLng(navInfo.getNavLongitude());
			marker.setIconImage(ThemeManager.getThemeResource(MODULE_ALERT_MARKER));
			marker.setIconAnchorX(ICON_ANCHOR_X);
			marker.setIconAnchorY(ICON_ANCHOR_Y);
			alertMarkers.put(id, marker);
			marker.setId(id);
			marker.setParent(gmaps);
		} else {
			marker = alertMarkers.get(id);
			marker.setLat(navInfo.getNavLatitude());
			marker.setLng(navInfo.getNavLongitude());
		}
	}

	private void getNavMarker(Gmarker marker, ModuleNavInfo navInfo) {
		marker.setContent("<b>" + navInfo.getName() + "</b>" + "<br>Дата: " + DF.format(navInfo.getNavDatetime())
				+ "<br>Скор.: " + navInfo.getNavSpeed() + "<br><i>Тел.: " + navInfo.getPhone() + "</i>");
		marker.setLat(navInfo.getNavLatitude());
		marker.setLng(navInfo.getNavLongitude());
		marker.setIconImage(getResourceName(navInfo));
		marker.setIconAnchorX(ICON_ANCHOR_X);
		marker.setIconAnchorY(ICON_ANCHOR_Y);
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
		return resourceName;
	}

	private String getIconFile(String baseName, double navСourse) {
		return ThemeManager.getThemeResource(baseName + "-" + (int) navСourse + ".png");
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

	@Override
	public boolean isPooling() {
		return true;
	}

	private void addModules() {
		for (ModuleNavInfo navInfo : GOOGLE_MAP_MODEL.getNavModules()) {
			logger.fine("Добавляем на карту объект: " + navInfo.getName());
			addModuleMarker(navInfo, getMarkerId(navInfo));
		}
	}

	private void addModulesRequest() {
		currRequests.clear();
		for (ModuleNavInfo navInfo : GOOGLE_MAP_MODEL.getNavRequestModules()) {
			currRequests.put(getMarkerId(navInfo), navInfo);
			addModuleMarker(navInfo, getMarkerId(navInfo));
		}
		ModuleNavInfo navInfo = new ModuleNavInfo();
		for (Map.Entry<String, ModuleNavInfo> entry : lastRequests.entrySet()) {
			if (currRequests.isEmpty() || !currRequests.containsKey(entry.getKey())) {
				navInfo = (ModuleNavInfo) entry.getValue();
				delModuleMarker(getMarkerId(navInfo));
			}
		}
		setLastRequests(currRequests);
	}

	public HashMap<String, ModuleNavInfo> getCurrRequests() {
		return currRequests;
	}

	public void setCurrRequests(HashMap<String, ModuleNavInfo> currRequests) {
		this.currRequests = currRequests;
	}

	private void delModuleMarker(String markerId) {
		if (markerId == null)
			return;
		delMarker(markerId);
	}

	private void addModuleMarker(ModuleNavInfo navInfo, String id) {
		if (navInfo == null)
			return;
		try {
			Gmarker marker = new Gmarker();
			getNavMarker(marker, navInfo);
			if (getAlertButton(navInfo).equals(BUTTON_ON)) {
				addMarkerAlert(navInfo);
				marker.setOpen(true);
			} else {
				removeMarkerAlert(navInfo);
			}
			if (getServiceButton(navInfo).equals(BUTTON_ON)) {
				addMarkerService(navInfo);
			} else {
				removeMarkerService(navInfo);
			}
			addMarker(marker, id);
		} catch (Exception e) {
			logger.severe("Ошибка добавление маркера : " + e.getMessage());
		}

	}

	private String getServiceButton(ModuleNavInfo navInfo) {
		String button = "";
		if (navInfo == null)
			return button;
		String key = getServiceKey(navInfo);
		if (key == null)
			return button;
		if (navInfo.getNavSensData() != null) {
			if (navInfo.getNavSensData().containsKey(key)) {
				button = navInfo.getNavSensData().get(key);
			}
		}
		return button;
	}

	private String getAlertButton(ModuleNavInfo navInfo) {
		String button = "";
		if (navInfo == null)
			return button;
		String key = getAlertKey(navInfo);
		if (key == null)
			return button;
		if (navInfo.getNavSensData() != null) {
			if (navInfo.getNavSensData().containsKey(key)) {
				button = navInfo.getNavSensData().get(key);
			}
		}
		return button;
	}

	private String getServiceKey(ModuleNavInfo navInfo) {
		if (!serviceKeys.containsKey(navInfo.getNmModule()) || serviceKeys.isEmpty()) {
			serviceKeys.put(navInfo.getNmModule(), GOOGLE_MAP_MODEL.getKey(navInfo, BUTTON_SERVICE));
		}
		return serviceKeys.get(navInfo.getNmModule());
	}

	private String getAlertKey(ModuleNavInfo navInfo) {
		if (!alertKeys.containsKey(navInfo.getNmModule()) || alertKeys.isEmpty()) {
			alertKeys.put(navInfo.getNmModule(), GOOGLE_MAP_MODEL.getKey(navInfo, BUTTON_ALERT));
		}
		return alertKeys.get(navInfo.getNmModule());
	}

	/**
	 *
	 */
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

	/**
	 * 
	 */
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
				MBPartner partner = new MBPartner(Env.getCtx(), m_C_BPartner_ID, null);
				showMarker(partner);
			}
		} else if (name.equals("A_Asset_ID")) {
			assetSearch.setValue(value);
			int m_A_Asset_ID = ((Integer) value).intValue();
			logger.fine("Ищем A_Asset_ID=" + m_A_Asset_ID);
			if (m_A_Asset_ID > 0) {
				MAsset asset = new MAsset(Env.getCtx(), m_A_Asset_ID, null);
				showMarker(asset);
			}
		}
	}

	private void showMarker(Object object) {
		String id = "";
		if (object instanceof MBPartner) {
			MBPartner partner = (MBPartner) object;
			id = getMarkerId(partner);
			Gmarker marker = getMarker(id);
			if (marker == null) {
				addBPartnerMarker(partner);
			} else {
				marker.setOpen(true);
			}
		} else if (object instanceof MAsset) {
			MAsset asset = (MAsset) object;
			id = getMarkerId(asset);
			Gmarker marker = getMarker(id);
			if (marker == null) {
				addAssetMarkers(asset);
			} else {
				marker.setOpen(true);
			}
		}

	}

	/**
	 * After Map init show only user location marker
	 */
	private void addUserMarker() {
		int location_id = 0;
		MUser user = MUser.get(Env.getCtx(), Env.getAD_User_ID(Env.getCtx()));
		location_id = user.getC_BPartner_Location_ID();
		if (location_id == 0)
			return;
		try {
			MBPartnerLocation bpl = new MBPartnerLocation(Env.getCtx(), location_id, null);
			if (bpl.getC_Location_ID() <= 0)
				return;
			MLocation location = MLocation.get(Env.getCtx(), bpl.getC_Location_ID(), null);
			SB_MARKER.setLength(0);
			SB_MARKER.append(location.getAddress1()).append(", ").append(location.getCity());
			address = nominatimClient.search(SB_MARKER.toString());
			// Add marker
			Gmarker marker = new Gmarker(Msg.translate(Env.getCtx(), bpl.getName()), address.getLatitude(),
					address.getLongitude());
			logger.severe("Add marker: Lat=" + address.getLatitude() + " Lon=" + address.getLongitude());
			marker.setOpen(false);
			marker.setIconImage(ThemeManager.getThemeResource(BPARTNER_MARKER));
			addMarker(marker, getMarkerId(bpl));
		} catch (Exception e) {
			logger.severe("DPGoogleMap.addUserMarker(): " + e.getMessage());
		}
	}

	/**
	 * Shift the position if many assets are on same position
	 */

	/**
	 * @param partner
	 */
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

	/**
	 * Add asset markers if they have location
	 */
	private void addAssetMarkers(Object object) {
		String condition = "";
		if (object instanceof MBPartner)
			condition = " C_BPartner_ID=" + ((MBPartner) object).getC_BPartner_ID();
		else if (object instanceof MAssetGroup)
			condition = " A_Asset_Group_ID=" + ((MAssetGroup) object).getA_Asset_Group_ID();

		int assetId[] = MAsset.getAllIDs(MAsset.Table_Name, condition, null);
		MAsset asset;
		MLocation location;

		for (int i = 0; i < assetId.length; i++) {
			asset = new MAsset(Env.getCtx(), assetId[i], null);
			if (asset.getC_Location_ID() > 0) {
				location = new MLocation(Env.getCtx(), asset.getC_Location_ID(), null);
				addMarkerLocation(location, asset);
			}
		}
	}

	/**
	 * Add marker on Map, based on GeoCoded location MBPartner MAsset
	 * 
	 * @param location
	 * @param partner
	 */
	private void addMarkerLocation(MLocation location, Object object) {
		LatLng latlng;
		String name = "";
		String imagePath = "";
		String id = "";
		SB_MARKER.setLength(0);
		if (location == null || object == null) {
			return;
		}
		try {
			if (object instanceof MBPartner) {
				MBPartner partner = (MBPartner) object;
				name = partner.getName();
				imagePath = BPARTNER_MARKER;
				id = getMarkerId(partner);
				SB_MARKER.append("<b>").append(name).append("</b><br>")
						.append(Msg.translate(Env.getCtx(), MBPartner.COLUMNNAME_TotalOpenBalance))
						.append(partner.getTotalOpenBalance()).append(getCurrencyCode(partner)).append("<br>")
						.append("<br><i>").append(location.getAddress1()).append(", ").append(location.getCity())
						.append("</i>");
			}
			latlng = locationToPoint(location);
			if (latlng == null) {
				logger.severe("DPGoogelMap: Failed to geocode location [" + location + "]");
				return;
			}
			Gmarker marker = new Gmarker(SB_MARKER.toString(), latlng.getLatitude(), latlng.getLongitude());
			marker.setOpen(false);
			marker.setIconImage(ThemeManager.getThemeResource(imagePath));
			marker.addEventListener(Events.ON_CLICK, DPGoogleMap.this);
			addMarker(marker, id);
		} catch (IOException e) {
			logger.severe("DPGoogelMap: Failed find location: " + e.getLocalizedMessage());
		}

	}

	/**
	 * @param location
	 * @param bPName
	 * @return
	 * @throws IOException
	 */
	private LatLng locationToPoint(MLocation location) throws IOException {
		if (location == null)
			return null;
		sbLoc.setLength(0);
		//
		try {
			sbLoc.append(location.getAddress1());
			if (location.getCity() != null && location.getCity().length() > 0)
				sbLoc.append(", ").append(location.getCity());
			// if (location.getPostal() != null && location.getPostal().length() > 0)
			// sbLoc.append(", ").append(location.getPostal());
			// if (location.getCountry() != null)
			// sbLoc.append(", ").append(location.getCountry());
			//
			address = nominatimClient.search(sbLoc.toString());
			LatLng latlng = null;
			// logger.severe(
			// "Адрес: " + address.getPlaceId() + " " + address.getLatitude() + ";" +
			// address.getLongitude());
			latlng = new LatLng(address.getLatitude(), address.getLongitude());
			if (latlng != null) {
				return latlng;
			}
		} catch (Exception e) {
			// TODO: handle exception
			logger.severe("Error get locations to point: " + e.getLocalizedMessage());

		}
		return null;
	}

	private Gmarker getMarker(String id) {
		if (markers.containsKey(id))
			return markers.get(id);
		return null;
	}

	private void addMarker(Gmarker marker, String id) {
		if (marker != null) {
			if (!markers.containsKey(id)) {
				markers.put(id, marker);
				marker.setId(id);
				marker.setParent(gmaps);
				// logger.severe("Добавили маркер : " + id + " иконка " +
				// marker.getIconImage());
			} else {
				markers.get(id).setLat(marker.getLat());
				markers.get(id).setLng(marker.getLng());
				markers.get(id).setContent(marker.getContent());
				if (!markers.get(id).getIconImage().equals(marker.getIconImage())) {
					markers.get(id).setIconImage(marker.getIconImage());
				}
				if (markers.get(id).isOpen() != marker.isOpen()) {
					markers.get(id).setOpen(marker.isOpen());
				}
			}
		}
	}

	private void delMarker(String id) {
		if (markers.containsKey(id)) {
			gmaps.removeChild(markers.get(id));
			markers.remove(id);
		}
	}

	/**
	 * @param partner
	 * @return
	 */
	private String getCurrencyCode(MBPartner partner) {
		Properties ctx = Env.getCtx();
		try {
			return " " + MClientInfo.get(ctx, AD_CLIENT_ID).getC_AcctSchema1().getC_Currency().getISO_Code();
		} catch (Exception e) {
			logger.severe(e.getMessage());
		}

		return "";
	}

	/**
	 * Add BPartners from database
	 */
	private void addBPartners() {
		for (int bPartner : GOOGLE_MAP_MODEL.getBPartner()) {
			addBPartnerMarker(MBPartner.get(Env.getCtx(), bPartner));
		}
	}

	/**
	 * 
	 */
	public void onEvent(Event e) {

		if (e instanceof MapMouseEvent) {
			MapMouseEvent mapEvent = (MapMouseEvent) e;
			Gmarker markerClick = mapEvent.getGmarker();
			if (markerClick != null) {
				if (markerClick.isOpen()) {
					markerClick.setOpen(false);
					markerClick.setFocus(false);
				} else {
					markerClick.setOpen(true);
					markerClick.setFocus(true);
					gmaps.setCenter(markerClick.getLat(), markerClick.getLng());
				}
			}
		}
	}// onEvent

	private static void scaleMap(Gmaps map) {

		Double minLat = null;
		Double maxLat = null;
		Double minLng = null;
		Double maxLng = null;

		// Work out the minimum and maximmum latitude and longitude
		//
		for (Object o : map.getChildren()) {
			if (o instanceof Gmarker) {
				Gmarker g = (Gmarker) o;

				if ((minLat == null) || (g.getLat() < minLat)) {
					minLat = g.getLat();
				}

				if ((maxLat == null) || (g.getLat() > maxLat)) {
					maxLat = g.getLat();
				}

				if ((minLng == null) || (g.getLng() < minLng)) {
					minLng = g.getLng();
				}

				if ((maxLng == null) || (g.getLng() > maxLng)) {
					maxLng = g.getLng();
				}
			}
		}

		// No markers found, so don't bother scaling
		if (minLat == null) {
			return;
		}

		// Calculate the centre Lat and Long
		//
		Double ctrLng = (maxLng + minLng) / 2;
		Double ctrLat = (maxLat + minLat) / 2;

		// The next calculation is sourced here
		// http://aiskahendra.blogspot.com/2009/01/set-zoom-level-of-google-map-base-on.html
		// I have no idea what it's actually doing !!!
		//
		Double interval = 0.0;

		int mapDisplay = 600; // Minimum of height or width of map in pixels

		// Some sort of tweak !
		if ((maxLat - minLat) > (maxLng - minLng)) {
			interval = (maxLat - minLat) / 2;
			minLng = ctrLng - interval;
			maxLng = ctrLng + interval;
		} else {
			interval = (maxLng - minLng) / 2;
			minLat = ctrLat - interval;
			maxLat = ctrLat + interval;
		}

		Double dist = (6371
				* Math.acos(Math.sin(minLat / 57.2958) * Math.sin(maxLat / 57.2958) + (Math.cos(minLat / 57.2958)
						* Math.cos(maxLat / 57.2958) * Math.cos((maxLng / 57.2958) - (minLng / 57.2958)))));

		// Note ... original calc used 8, but I found it worked better with 7
		Double zoom = Math.floor(7 - Math.log(1.6446 * dist / Math.sqrt(2 * (mapDisplay * mapDisplay))) / Math.log(2));

		// Centre the map
		map.setCenter(ctrLat, ctrLng);

		// Set appropriate zoom
		map.setZoom(zoom.intValue());
	}
}
