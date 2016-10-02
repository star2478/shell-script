
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import com.alibaba.fastjson.JSONArray;
//import com.sun.org.apache.xpath.internal.operations.String;

/**
 * 
 * @author heliuxing
 *
 */
public class parseJson {
	public static void parse(String fileName, String type) {
        File file = new File(fileName);
        BufferedReader reader = null;
        
        try {
            reader = new BufferedReader(new FileReader(file));
            String tempString = null;
            // 一次读入一行，直到读入null为文件结束
            while ((tempString = reader.readLine()) != null) {
            	List<Object> list = JSONArray.parseArray("["+tempString+"]");
            	Map<String, Object> map = (Map<String, Object>) list.get(0);
            	Map<String, Object> daily = (Map<String, Object>) map.get("data");
            	List<Map<String, Object>> bankList = (List<Map<String, Object>>) daily.get("appDailyCountList");
            	for (Map<String, Object> map2 : bankList) {
            		String bankName = (String) map2.get("bankName") + "-" + type;
            		List<Map<String, Object>> dailyCountList = (List<Map<String, Object>>) map2.get("dailyCountList");
            		Map<String, Object> today = dailyCountList.get(0);
            		Integer totalUserCount = (Integer) today.get("totalUserCount");
            		File wfile = new File("userNum/"+bankName);
                    if(!wfile.exists()){
                    	wfile.createNewFile();
                    }
                    //true = append file
//					FileWriter fileWritter = new FileWriter(wfile.getName(), true);
//					BufferedWriter bufferWritter = new BufferedWriter(fileWritter);
//					bufferWritter.write("sdd"+totalUserCount);
//					bufferWritter.close();
//					System.out.println(totalUserCount);
					FileOutputStream out=new FileOutputStream(wfile,false); //如果追加方式用true
			        out.write(totalUserCount.toString().getBytes("utf-8"));//注意需要转换对应的字符集
			        out.close();
				}
				
                break;
            }
            reader.close();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e1) {
                }
            }
        }
    }
	
	public static void main(String[] args) {
		String jsonFile = args[0];
		String os = args[1];
		parse(jsonFile, os);
		System.out.println("finish parse userNum");
	}

}
