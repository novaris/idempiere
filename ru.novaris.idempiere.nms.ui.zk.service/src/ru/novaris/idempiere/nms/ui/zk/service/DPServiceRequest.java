package ru.novaris.idempiere.nms.ui.zk.service;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;

import org.adempiere.webui.component.Button;
import org.adempiere.webui.dashboard.DashboardPanel;
import org.adempiere.webui.session.SessionManager;
import org.adempiere.webui.theme.ThemeManager;
import org.adempiere.webui.util.ServerPushTemplate;
import org.compiere.util.CLogger;
import org.compiere.util.Env;
import org.compiere.util.Msg;
import org.compiere.util.Util;
import org.zkoss.zk.ui.Component;
import org.zkoss.zk.ui.event.Event;
import org.zkoss.zk.ui.event.EventListener;
import org.zkoss.zk.ui.event.EventQueue;
import org.zkoss.zk.ui.event.EventQueues;
import org.zkoss.zk.ui.event.Events;
import org.zkoss.zul.Vbox;

public class DPServiceRequest extends DashboardPanel implements
		EventListener<Event> {
	/**
	 * 
	 */
	private static final long serialVersionUID = -9159634289804388209L;

	private static final CLogger logger = CLogger
			.getCLogger(DPServiceRequest.class);

	private Button btnServiceRequest;

	private String labelR;

	private int noOfRequest;

	public final String SERVICE_REQUEST_EVENT_QUEUE = "ServiceRequestEventQueue";
	public final String ON_SERVICE_REQUEST_CHANGED_EVENT = "onServiceRequestChanged";

	public DPServiceRequest() {
		super();
		initLayout();
		initComponent();
	}

	private void initComponent() {
		this.appendChild(createServiceRequestsPanel());
	}

	private void initLayout() {
		this.setSclass("activities-box");
		this.setVflex("0");
		this.setHflex("0");
	}

	@Override
	public void refresh(ServerPushTemplate template) {
		int request = DPServiceRequestModel.getServiceRequestCount();
		if (noOfRequest != request) {
			noOfRequest = request;
			template.executeAsync(this);
		}
	}

	@Override
	public void updateUI() {
		btnServiceRequest.setLabel(labelR + " : " + noOfRequest);
		EventQueue<Event> queue = EventQueues.lookup(
				this.SERVICE_REQUEST_EVENT_QUEUE, true);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("request", noOfRequest);
		Event event = new Event(this.ON_SERVICE_REQUEST_CHANGED_EVENT, null,
				map);
		queue.publish(event);
	}

	@Override
	public boolean isPooling() {
		return true;
	}

	private Vbox createServiceRequestsPanel() {
		Vbox vbox = new Vbox();
		labelR = Util.cleanAmp(Msg.translate(Env.getCtx(),
				"NM_Service_Request_V_ID"));
		btnServiceRequest = new Button();
		vbox.appendChild(btnServiceRequest);
		btnServiceRequest.setLabel(labelR + " : 0");
		btnServiceRequest.setTooltiptext(labelR);
		btnServiceRequest.setImage(ThemeManager
				.getThemeResource("images/Request16.png"));
		btnServiceRequest.setName(String.valueOf(DPServiceRequestModel.getAdMenuId()));
		btnServiceRequest.addEventListener(Events.ON_CLICK, this);
		return vbox;
	}


	public void onEvent(Event event) {
		Component comp = event.getTarget();
		String eventName = event.getName();
		if (eventName.equals(Events.ON_CLICK)) {
			if (comp instanceof Button) {
				Button btn = (Button) comp;
				int menuId = 0;
				try {
					menuId = Integer.valueOf(btn.getName());
				} catch (Exception e) {
					logger.log(Level.SEVERE, e.getMessage());
				}
				if (menuId > 0)
					SessionManager.getAppDesktop().onMenuSelected(menuId);
			}
		}
	}

}
