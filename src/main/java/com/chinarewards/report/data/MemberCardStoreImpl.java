/**
 * 
 */
package com.chinarewards.report.data;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

/**
 * 
 * 
 * @author Cyril
 * @since 1.3.0 2010-01-23
 */
public class MemberCardStoreImpl {

	/**
	 * Returns the list of China Rewards internal staff card number list.
	 * <p>
	 * Current implementation reads the file 'cr_staff_card_list.txt as a
	 * resource stream.
	 * 
	 * @return
	 */
	public List<String> getChinaRewardsCardNumberList()
			throws MemberCardStoreException {

		BufferedReader reader = null;
		ArrayList<String> list = new ArrayList<String>();
		
		try {
			// open the file as resource
			reader = new BufferedReader(new InputStreamReader(getClass()
					.getResourceAsStream("/cr_staff_card_list.txt"), "UTF-8"));
			String s = null;
			
			// read the file line by line and add the line to the array.
			while ((s = reader.readLine()) != null) {
				if (s == null) break;	// EOF
				
				s = s.trim();
				
				// skip empty lines
				if (s.length() <= 0) continue;
				list.add(s);
			}
			
		} catch (IOException e) {
			throw new MemberCardStoreException(e);
		} finally {
			if (reader != null) {
				try {
					reader.close();
				} catch (Throwable t) {
				}
			}
		}

		return list;
	}
}
