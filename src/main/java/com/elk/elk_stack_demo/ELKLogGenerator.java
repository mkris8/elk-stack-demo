package com.elk.elk_stack_demo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ELKLogGenerator {

	private static final Logger LOGGER = LoggerFactory.getLogger(ELKLogGenerator.class);

	public static void main(String[] args) throws Exception {

		for (int i = 0; i < 10; i++) {

			LOGGER.info("This is an ELK info to kibana");
			LOGGER.warn("This is an ELK warning to kibana");
			LOGGER.error("This is an ELK error to kibana");

			Thread.sleep(200);
		}
	}

}
