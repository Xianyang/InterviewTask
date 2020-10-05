package com.xianyang.randomStringApp;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.util.Random;

@SpringBootApplication
@RestController
public class RandomStringAppApplication {

	public static void main(String[] args) {
		SpringApplication.run(RandomStringAppApplication.class, args);
	}

	@GetMapping("/randomString")
	public String randomString(String name) {
		String randomString = randomStringGenerator();

		return String.format(randomString, name);
	}

	public String randomStringGenerator() {
		String chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijk" + "lmnopqrstuvwxyz!@#$%&";
		Random rnd = new Random();

		int len = 10;
		StringBuilder sb = new StringBuilder(len);
		for (int i = 0; i < len; i++)
			sb.append(chars.charAt(rnd.nextInt(chars.length())));
		return sb.toString();
	}

}
