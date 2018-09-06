package ru.novaris.idempiere.ui.zk.nominatim;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.compiere.util.CLogger;

import com.google.gson.Gson;

import ru.novaris.idempiere.ui.zk.nominatim.model.Address;

public class JsonNominatimClient {

	private final CloseableHttpClient httpclient;
	private final String searchUrl;
	private String emailEncoded;
	public static CLogger logger = CLogger.getCLogger(JsonNominatimClient.class);
	private Address address;
	private final Gson gsonInstance;

	public JsonNominatimClient(String searchUrl, CloseableHttpClient httpclient, String email) {
		this.httpclient = httpclient;
		this.searchUrl = searchUrl;
		this.gsonInstance = new Gson();
		this.address = new Address();
		try {
			this.emailEncoded = URLEncoder.encode(email, "UTF-8");
		} catch (UnsupportedEncodingException e) {
			this.emailEncoded = email;
		}
	}

	public Address search(String parameters) throws ClientProtocolException, IOException {
		address = null;
		InputStream content = null;
		final String apiCall = String.format("%s/search?format=jsonv2&email=%s&addressdetails=0&limit=1&q=%s",
				searchUrl, emailEncoded, URLEncoder.encode(parameters, "UTF-8"));
		final HttpGet req = new HttpGet(apiCall);
		HttpResponse response = httpclient.execute(req);
		int statusCode = response.getStatusLine().getStatusCode();
		if (statusCode != HttpStatus.SC_OK) {
			logger.severe("Ошибка обработки запроса : " + apiCall + " код HTTP : " + statusCode);
			return address;
		}
		try {
			content = response.getEntity().getContent();
			address = (gsonInstance.fromJson(new InputStreamReader(content, "utf-8"), Address[].class))[0];
			/*
			 * [{"place_id":"111478"
			 * ,"licence":"Data © OpenStreetMap contributors,ODbL 1.0. http:\/\/www.openstreetmap.org\/copyright"
			 * ,"osm_type":"node" ,"osm_id":"4270030552"
			 * ,"boundingbox":["55.0187407","55.0188407","82.968836","82.968936"]
			 * ,"lat":"55.0187907" ,"lon":"82.968886"
			 * ,"display_name":"Майами БиС!!, 98\/1, улица Никитина, Октябрьский район, Новосибирск, городской округ Новосибирск, Новосибирская область, 630039, Россия"
			 * ,"place_rank":"30" ,"category":"leisure" ,"type":"sauna"
			 * ,"importance":0.211}]
			 */
			return address;
		} finally {
			if (null != content) {
				content.close();
			}
		}
	}

}
