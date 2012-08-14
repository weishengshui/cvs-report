/**
 * 
 */
package com.chinarewards.report.data;

/**
 * 
 * 
 * @author Cyril
 * @since 1.3.0 2010-01-23
 */
public class MemberCardStoreException extends Exception {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6074857603229121789L;

	/**
	 * 
	 */
	public MemberCardStoreException() {
	}

	/**
	 * @param message
	 */
	public MemberCardStoreException(String message) {
		super(message);
	}

	/**
	 * @param cause
	 */
	public MemberCardStoreException(Throwable cause) {
		super(cause);
	}

	/**
	 * @param message
	 * @param cause
	 */
	public MemberCardStoreException(String message, Throwable cause) {
		super(message, cause);
	}

}
