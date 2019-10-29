package HbigDataCollector;

import java.io.FileWriter;
import java.io.IOException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.jsoup.Jsoup;

public class RealTimeDataCollector {

	public static void main(String[] args) throws ParseException, Exception {
		

		String jsonBikeData1 = Jsoup.connect("http://openapi.seoul.go.kr:8088/51444a447365686538356456586166/json/bikeList/1/1000/").ignoreContentType(true).execute().body();
		String jsonBikeData2 = Jsoup.connect("http://openapi.seoul.go.kr:8088/51444a447365686538356456586166/json/bikeList/1001/2000/").ignoreContentType(true).execute().body();
		
		JSONParser jsonParser = new JSONParser();
		JSONObject obj = new JSONObject();
		
		JSONObject jsonObject1 = (JSONObject)jsonParser.parse(jsonBikeData1);
		JSONObject jsonObject2 = (JSONObject)jsonParser.parse(jsonBikeData2);
		
		JSONObject json1 = (JSONObject)jsonObject1.get("rentBikeStatus");
		JSONObject json2 = (JSONObject)jsonObject2.get("rentBikeStatus");
		
		System.out.println(json1);
		JSONArray array1 = (JSONArray)json1.get("row");
		JSONArray array2 = (JSONArray)json2.get("row");
		
		FileWriter file = new FileWriter("c:\\Jsondata\\bikedata.json");
		
		for(int i=0; i<array1.size(); i++){
			
			JSONObject row = (JSONObject)array1.get(i);
			
			System.out.println("첫번째"+row);
			
			file.write(JSONObject.toJSONString(row));
			
		}
		
		for(int i=0; i<array2.size(); i++){
			
			JSONObject row = (JSONObject)array2.get(i);
			
			System.out.println("두번째"+row);
			
			file.write(JSONObject.toJSONString(row));
			
		}
	 
		try {
	 
			
			
			file.flush();
			file.close();
	 
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
