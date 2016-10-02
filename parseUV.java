
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
import java.util.*;
import java.util.concurrent.TimeUnit;

import com.sun.org.apache.xpath.internal.operations.String;

import javafx.scene.shape.Line;

import java.net.URLEncoder;

//import com.sun.org.apache.xpath.internal.operations.String;

//import com.alibaba.fastjson.JSONArray;
//import com.sun.org.apache.xpath.internal.operations.String;

/**
 * 
 * @author heliuxing
 *
 */
public class parseUV {
	public static void parse(String fileName) {
        File file = new File(fileName);
        BufferedReader reader = null;
        
        try {
            reader = new BufferedReader(new FileReader(file));
            String line = null;
            // 一次读入一行，直到读入null为文件结束
            while ((line = reader.readLine()) != null) {
            	String xmString = new String(line.toString().getBytes("UTF-8"));  
                String xmlUTF8 = URLEncoder.encode(xmString, "UTF-8");
                String xmString1 = new String(line.toString().getBytes("GB2312"));  
                String xmlGbk = URLEncoder.encode(xmString1, "GB2312");
            	System.out.println(line);
            	System.out.println("================");
            	System.out.println(xmlUTF8);
            	System.out.println("================");
            	System.out.println(xmlGbk);
            	System.out.println("================");
            	String[] arrStrings = line.split(",");
            	for (String string : arrStrings) {
					System.out.println(string);
				}
//            	List<Object> list = JSONArray.parseArray("["+line+"]");
//            	Map<String, Object> map = (Map<String, Object>) list.get(0);
//            	Map<String, Object> daily = (Map<String, Object>) map.get("data");
//            	List<Map<String, Object>> bankList = (List<Map<String, Object>>) daily.get("appDailyCountList");
//            	for (Map<String, Object> map2 : bankList) {
//            		String bankName = (String) map2.get("bankName") + "-" + type;
//            		List<Map<String, Object>> dailyCountList = (List<Map<String, Object>>) map2.get("dailyCountList");
//            		Map<String, Object> today = dailyCountList.get(0);
//            		Integer totalUserCount = (Integer) today.get("totalUserCount");
//            		File wfile = new File("userNum/"+bankName);
//                    if(!wfile.exists()){
//                    	wfile.createNewFile();
//                    }
//					FileOutputStream out=new FileOutputStream(wfile,false); //如果追加方式用true
//			        out.write(totalUserCount.toString().getBytes("utf-8"));//注意需要转换对应的字符集
//			        out.close();
//				}
				
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
		String file = args[0];
		System.out.println(file);
		parse(file);
		System.out.println("finish parse");
	}

}
