package ru.novaris.idempiere.nms.ui.zk.openlayers;

import org.zkoss.openlayers.base.LonLat;

public class ZoomCenter {
	private LonLat center;
	private Integer zoom;
	public LonLat getCenter() {
		return center;
	}
	public void setCenter(LonLat lonLat) {
		this.center = lonLat;
	}
	public Integer getZoom() {
		return zoom;
	}
	public void setZoom(Integer zoom) {
		this.zoom = zoom;
	}

}
