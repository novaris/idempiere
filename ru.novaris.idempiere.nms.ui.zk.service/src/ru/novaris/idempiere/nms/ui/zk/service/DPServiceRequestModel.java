package ru.novaris.idempiere.nms.ui.zk.service;

import org.compiere.model.MRole;
import org.compiere.util.CLogger;
import org.compiere.util.DB;
import org.compiere.util.Env;

public class DPServiceRequestModel {
	private static final CLogger logger = CLogger
			.getCLogger(DPServiceRequestModel.class);

	public static boolean isShowUnprocessed() {
		return (Env.getAD_Client_ID(Env.getCtx()) > 0);
	}

	private final static String sqlRequest = MRole
			.getDefault()
			.addAccessSQL(
					new StringBuffer()
							.append("SELECT COUNT(1) FROM NM_Service_Request_V ")
							.append("WHERE AD_User_ID=? AND Processed='N'")
							.append(" AND (DateNextAction IS NULL")
							.append("  OR TRUNC(DateNextAction) <= TRUNC(SysDate))")
							.append(" AND (R_Status_ID IS NULL OR R_Status_ID ")
							.append("  IN (SELECT R_Status_ID FROM R_Status WHERE IsClosed='N'))")
							.toString(), "NM_Service_Request_V",
					MRole.SQL_FULLYQUALIFIED, MRole.SQL_RO);

	private final static String sqlMenu = "SELECT AD_Menu_ID FROM AD_Menu WHERE Name = 'Service Request' AND IsSummary = 'N'";

	/**
	 * Get service request count
	 * 
	 * @return number of service request
	 */
	public static int getServiceRequestCount() {
		logger.fine(sqlRequest);
		int retValue = DB.getSQLValue(null, sqlRequest,
				Env.getAD_User_ID(Env.getCtx()));
		return retValue;
	}

	public static int getAdMenuId() {
		return DB
				.getSQLValue(
						null,
						sqlMenu);
	}
}
