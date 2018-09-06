package ru.novaris.idempiere.nms.ui.zk.openlayers;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;

import org.compiere.model.MRole;
import org.compiere.util.CLogger;
import org.compiere.util.DB;
import org.compiere.util.Env;

public class DPOpenlayersMapModel
{
	private static final CLogger	logger			= CLogger.getCLogger(DPOpenlayersMapModel.class);
	private Timestamp				lastDate;
	private List<ModuleNavInfo>		modulesLastNavInfo;
	private List<ModuleNavInfo>		currentRequests;
	private List<Integer>			bPartners;

	private PreparedStatement		pstmt			= null;
	private ResultSet				rs				= null;

	private final String			sqlSensorKey	= new StringBuffer().append("SELECT s.SensorKey ")
			.append("  FROM NM_Sensor s ").append(" WHERE s.IsActive = 'Y'::bpchar ")
			.append("   AND s.NM_Module_ID = ? ").append("   AND s.NM_Sensor_Type_ID = ? ").toString();

	public Timestamp getLastDate()
	{
		return lastDate;
	}

	public DPOpenlayersMapModel()
	{
		lastDate = new Timestamp(0);
		modulesLastNavInfo = new ArrayList<ModuleNavInfo>();
		currentRequests = new ArrayList<ModuleNavInfo>();
		bPartners = new ArrayList<Integer>();
	}

	@SuppressWarnings({ "unchecked" })
	public List<ModuleNavInfo> getNavInfoModules()
	{
		modulesLastNavInfo.clear();
		StringBuffer sb = new StringBuffer().append("SELECT DISTINCT l.Nav_ID").append(" ,l.Nav_Datetime")
				.append(" ,l.Updated").append(" ,l.Nav_Sens_Data").append(" ,l.Nav_Latitude")
				.append(" ,l.Nav_Longitude").append(" ,l.Nav_Sog").append(" ,l.Nav_Course").append(" ,m.NM_Module_ID")
				.append(" ,a.A_Asset_ID").append(" ,a.AD_User_ID").append(" ,a.AD_Org_ID").append(" ,a.AD_Client_ID")
				.append(" ,a.C_BPartner_ID").append(" ,a.Name").append(" ,u.Phone")
				.append(" ,get_color_status((l.Nav_Sens_Data -> s.SensorKey::text)::character varying, r.R_Status_ID, l.Nav_Datetime) AS Nav_Color")
				.append(" FROM a_asset a").append(" INNER JOIN AD_User u ON (a.AD_User_ID = u.AD_User_ID)")
				.append(" INNER JOIN NM_Module m ON (m.IsActive = 'Y'::bpchar AND a.A_Asset_ID = m.A_Asset_ID)")
				.append(" INNER JOIN NM_Nav_Data_Last l ON (l.NM_Module_ID = m.NM_Module_ID)")
				.append(" LEFT JOIN NM_Sensor s ON (m.NM_Module_ID = s.NM_Module_ID AND s.IsActive = 'Y'::bpchar AND s.NM_Sensor_Type_ID = 6)")
				.append(" LEFT JOIN R_Request r ON (r.A_Asset_ID = a.A_Asset_ID)")
				.append(" WHERE a.IsActive = 'Y'::bpchar AND a.AD_User_ID IS NOT NULL AND l.Updated > ? ORDER BY l.Updated");
		String sql = MRole.getDefault().addAccessSQL(sb.toString(), "a", MRole.SQL_FULLYQUALIFIED, MRole.SQL_RO);
		logger.fine(sql);
		try
		{
			pstmt = DB.prepareStatement(sql, null);
			pstmt.setTimestamp(1, lastDate);
			rs = pstmt.executeQuery();
			if (rs.next())
			{
				ModuleNavInfo navInfo = new ModuleNavInfo();
				navInfo.setNav(rs.getLong("Nav_ID"));
				navInfo.setNavDatetime(rs.getTimestamp("Nav_Datetime"));
				navInfo.setUpdated(rs.getTimestamp("Updated"));
				navInfo.setNavSensData((Map<String, String>) rs.getObject("Nav_Sens_Data"));
				navInfo.setNavLatitude(rs.getDouble("Nav_Latitude"));
				navInfo.setNavLongitude(rs.getDouble("Nav_Longitude"));
				navInfo.setNmModule(rs.getLong("NM_Module_ID"));
				navInfo.setaAsset(rs.getLong("A_Asset_ID"));
				navInfo.setAdUser(rs.getLong("AD_User_ID"));
				navInfo.setAdOrg(rs.getLong("AD_Org_ID"));
				navInfo.setAdClient(rs.getLong("AD_Client_ID"));
				navInfo.setcBPartner(rs.getLong("C_BPartner_ID"));
				navInfo.setName(rs.getString("Name"));
				navInfo.setPhone(rs.getString("Phone"));
				navInfo.setNavSpeed(rs.getDouble("Nav_Sog"));
				navInfo.setNavСourse(rs.getDouble("Nav_Course"));
				modulesLastNavInfo.add(navInfo);
				setLastDate(navInfo.getUpdated());
			}
		}
		catch (Exception e)
		{
			logger.log(Level.SEVERE, sql, e);
		}
		finally
		{
			DB.close(rs, pstmt);
			rs = null;
			pstmt = null;
		}
		return modulesLastNavInfo;
	}

	public void setLastDate(Timestamp lastModifyDate)
	{
		lastDate = lastModifyDate;

	}

	public static boolean isShowUnprocessed()
	{
		return (Env.getAD_Client_ID(Env.getCtx()) > 0);
	}

	@SuppressWarnings("unchecked")
	public List<ModuleNavInfo> getNavRequestModules()
	{
		StringBuffer sb = new StringBuffer().append("SELECT DISTINCT l.Nav_ID,").append(" l.Nav_Datetime,")
				.append(" l.Updated,").append(" l.Nav_Sens_Data,").append(" l.Nav_Latitude,")
				.append(" l.Nav_Longitude,").append(" l.Nav_Sog,").append(" l.Nav_Course,").append(" m.NM_Module_ID,")
				.append(" a.A_Asset_ID,").append(" a.AD_User_ID,").append(" a.AD_Org_ID,").append(" a.AD_Client_ID,")
				.append(" a.C_BPartner_ID,").append(" a.Name,").append(" u.Phone").append(" FROM R_Request r1")
				.append(" INNER JOIN A_Asset a ON (r1.A_Asset_ID = a.A_Asset_ID)")
				.append(" INNER JOIN R_Request r ON (r1.R_Request_ID = r.R_RequestRelated_ID AND r.Processed = 'N')")
				.append(" INNER JOIN C_Order o ON (r.C_Order_ID = o.C_Order_ID)")
				.append(" INNER JOIN AD_User u ON (a.AD_User_ID = u.AD_User_ID)")
				.append(" INNER JOIN C_RfQ c ON (o.C_Order_ID = c.C_Order_ID)")
				.append(" INNER JOIN C_RfQResponse c1 ON (c.C_RfQ_ID = c1.C_RfQ_ID)").append(" INNER JOIN NM_Module m")
				.append("    ON (m.IsActive = 'Y'::bpchar AND a.A_Asset_ID = m.A_Asset_ID)")
				.append(" INNER JOIN NM_Nav_Data_Last l ON (l.NM_Module_ID = m.NM_Module_ID)")
				.append("WHERE a.IsActive = 'Y'::bpchar AND a.AD_User_ID IS NOT NULL AND c1.AD_User_ID = ?");
		String sql = sb.toString();
		logger.fine(sql);
		try
		{
			pstmt = DB.prepareStatement(sql, null);
			pstmt.setInt(1, Env.getAD_User_ID(Env.getCtx()));
			rs = pstmt.executeQuery();
			currentRequests.clear();
			while (rs.next())
			{
				ModuleNavInfo navInfo = new ModuleNavInfo();
				navInfo.setNav(rs.getLong("Nav_ID"));
				navInfo.setNavDatetime(rs.getTimestamp("Nav_Datetime"));
				navInfo.setUpdated(rs.getTimestamp("updated"));
				navInfo.setNavSensData((Map<String, String>) rs.getObject("Nav_Sens_Data"));
				navInfo.setNavLatitude(rs.getDouble("Nav_Latitude"));
				navInfo.setNavLongitude(rs.getDouble("Nav_Longitude"));
				navInfo.setNmModule(rs.getLong("Nm_Module_ID"));
				navInfo.setaAsset(rs.getLong("A_Asset_ID"));
				navInfo.setAdUser(rs.getLong("AD_User_ID"));
				navInfo.setAdOrg(rs.getLong("AD_Org_ID"));
				navInfo.setAdClient(rs.getLong("AD_Client_ID"));
				navInfo.setcBPartner(rs.getLong("C_BPartner_ID"));
				navInfo.setName(rs.getString("Name"));
				navInfo.setPhone(rs.getString("Phone"));
				navInfo.setNavSpeed(rs.getDouble("Nav_Sog"));
				navInfo.setNavСourse(rs.getDouble("Nav_Course"));
				currentRequests.add(navInfo);
			}
		}
		catch (Exception e)
		{
			logger.log(Level.SEVERE, sql.toString(), e);
		}
		finally
		{
			DB.close(rs, pstmt);
			rs = null;
			pstmt = null;
		}
		return currentRequests;
	}

	@SuppressWarnings("unchecked")
	public List<ModuleNavInfo> getNavModules()
	{
		List<ModuleNavInfo> modules = new ArrayList<ModuleNavInfo>();
		StringBuffer sb = new StringBuffer().append("SELECT DISTINCT l.Nav_ID").append(" ,l.Nav_Datetime")
				.append(" ,l.Updated").append(" ,l.Nav_Sens_Data").append(" ,l.Nav_Latitude")
				.append(" ,l.Nav_Longitude").append(" ,l.Nav_Sog").append(" ,l.Nav_Course").append(" ,m.NM_Module_ID")
				.append(" ,a.A_Asset_ID").append(" ,a.AD_User_ID").append(" ,a.AD_Org_ID").append(" ,a.AD_Client_ID")
				.append(" ,a.C_BPartner_ID").append(" ,a.Name").append(" ,u.Phone").append(" FROM A_Asset a")
				.append(" INNER JOIN AD_User u ON (a.AD_User_ID = u.AD_User_ID)")
				.append(" INNER JOIN NM_Module m ON (m.IsActive = 'Y'::bpchar AND a.A_Asset_ID = m.A_Asset_ID)")
				.append(" INNER JOIN NM_Nav_Data_Last l ON (l.NM_Module_ID = m.NM_Module_ID )")
				.append(" WHERE a.IsActive = 'Y'::bpchar AND a.AD_User_ID IS NOT NULL");
		String sql = MRole.getDefault().addAccessSQL(sb.toString(), "a", MRole.SQL_FULLYQUALIFIED, MRole.SQL_RO);
		logger.fine(sql);
		try
		{
			pstmt = DB.prepareStatement(sql, null);
			rs = pstmt.executeQuery();
			while (rs.next())
			{
				ModuleNavInfo navInfo = new ModuleNavInfo();
				navInfo.setNav(rs.getLong("Nav_ID"));
				navInfo.setNavDatetime(rs.getTimestamp("Nav_Datetime"));
				navInfo.setUpdated(rs.getTimestamp("Updated"));
				navInfo.setNavSensData((Map<String, String>) rs.getObject("Nav_Sens_Data"));
				navInfo.setNavLatitude(rs.getDouble("Nav_Latitude"));
				navInfo.setNavLongitude(rs.getDouble("Nav_Longitude"));
				navInfo.setNmModule(rs.getLong("Nm_Module_ID"));
				navInfo.setaAsset(rs.getLong("A_Asset_ID"));
				navInfo.setAdUser(rs.getLong("AD_User_ID"));
				navInfo.setAdOrg(rs.getLong("AD_Org_ID"));
				navInfo.setAdClient(rs.getLong("AD_Client_ID"));
				navInfo.setcBPartner(rs.getLong("C_BPartner_ID"));
				navInfo.setName(rs.getString("Name"));
				navInfo.setPhone(rs.getString("Phone"));
				navInfo.setNavSpeed(rs.getDouble("Nav_Sog"));
				navInfo.setNavСourse(rs.getDouble("Nav_Course"));
				modules.add(navInfo);
			}
		}
		catch (Exception e)
		{
			logger.log(Level.SEVERE, sql.toString(), e);
		}
		finally
		{
			DB.close(rs, pstmt);
			rs = null;
			pstmt = null;
		}
		return modules;
	}

	public List<Integer> getBPartner()
	{
		StringBuffer sb = new StringBuffer().append("SELECT DISTINCT b.C_BPartner_ID").append("  FROM C_BPartner b")
				.append("  INNER JOIN C_BPartner_Location l ON (b.C_BPartner_ID = l.C_BPartner_ID AND l.IsActive = 'Y')")
				.append(" WHERE b.IsActive = 'Y'");
		String sql = MRole.getDefault().addAccessSQL(sb.toString(), "b", MRole.SQL_FULLYQUALIFIED, MRole.SQL_RO);
		logger.fine(sql);
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try
		{
			pstmt = DB.prepareStatement(sql, null);
			rs = pstmt.executeQuery();
			while (rs.next())
			{
				bPartners.add(rs.getInt("C_BPartner_ID"));
			}
		}
		catch (Exception e)
		{
			logger.log(Level.SEVERE, sql, e);
		}
		finally
		{
			DB.close(rs, pstmt);
			rs = null;
			pstmt = null;
		}
		return bPartners;
	}

	public String getKey(ModuleNavInfo navInfo, long keyType)
	{
		String key = "";
		try
		{
			pstmt = DB.prepareStatement(sqlSensorKey, null);
			pstmt.setLong(1, navInfo.getNmModule());
			pstmt.setLong(2, keyType);
			rs = pstmt.executeQuery();
			if (rs.next())
			{
				key = rs.getString("SensorKey");
			}
		}
		catch (Exception e)
		{
			logger.log(Level.SEVERE, sqlSensorKey, e);
		}
		finally
		{
			DB.close(rs, pstmt);
			rs = null;
			pstmt = null;
		}
		return key;
	}

}
