package ru.novaris.idempiere.nms.ui.zk.openlayers;

import java.sql.Timestamp;
import java.util.Map;

public class ModuleNavInfo
{
	public ModuleNavInfo()
	{

	}

	private long				nav;
	private Timestamp			navDatetime;
	private Timestamp			updated;
	private Map<String, String>	navSensData;
	private double				navLatitude;
	private double				navLongitude;
	private long				nmModule;
	private long				aAsset;
	private long				adUser;
	private long				adOrg;
	private long				adClient;
	private long				cBPartner;
	private String				name;
	private String				phone;
	private double				navSpeed;
	private double				navСourse;

	public long getNav()
	{
		return nav;
	}

	public void setNav(long nav)
	{
		this.nav = nav;
	}

	public Timestamp getNavDatetime()
	{
		return navDatetime;
	}

	public void setNavDatetime(Timestamp navDatetime)
	{
		this.navDatetime = navDatetime;
	}

	public Timestamp getUpdated()
	{
		return updated;
	}

	public void setUpdated(Timestamp updated)
	{
		this.updated = updated;
	}

	public Map<String, String> getNavSensData()
	{
		return navSensData;
	}

	public void setNavSensData(Map<String, String> map)
	{
		this.navSensData = map;
	}

	public double getNavLatitude()
	{
		return navLatitude;
	}

	public void setNavLatitude(double navLatitude)
	{
		this.navLatitude = navLatitude;
	}

	public double getNavLongitude()
	{
		return navLongitude;
	}

	public void setNavLongitude(double navLongitude)
	{
		this.navLongitude = navLongitude;
	}

	public long getNmModule()
	{
		return nmModule;
	}

	public void setNmModule(long nmModule)
	{
		this.nmModule = nmModule;
	}

	public long getaAsset()
	{
		return aAsset;
	}

	public void setaAsset(long aAsset)
	{
		this.aAsset = aAsset;
	}

	public long getAdUser()
	{
		return adUser;
	}

	public void setAdUser(long adUser)
	{
		this.adUser = adUser;
	}

	public long getAdOrg()
	{
		return adOrg;
	}

	public void setAdOrg(long adOrg)
	{
		this.adOrg = adOrg;
	}

	public long getAdClient()
	{
		return adClient;
	}

	public void setAdClient(long adClient)
	{
		this.adClient = adClient;
	}

	public long getcBPartner()
	{
		return cBPartner;
	}

	public void setcBPartner(long cBPartner)
	{
		this.cBPartner = cBPartner;
	}

	public String getName()
	{
		return name;
	}

	public void setName(String name)
	{
		this.name = name;
	}

	public String getPhone()
	{
		return phone;
	}

	public void setPhone(String phone)
	{
		this.phone = phone;
	}

	public double getNavSpeed()
	{
		return navSpeed;
	}

	public void setNavSpeed(double navSpeed)
	{
		this.navSpeed = navSpeed;
	}

	public double getNavСourse()
	{
		return navСourse;
	}

	public void setNavСourse(double navСourse)
	{
		this.navСourse = navСourse;
	}

}
