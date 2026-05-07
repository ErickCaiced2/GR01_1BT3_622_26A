package com.example.gr01_1bt3_622_26a;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class Gr011Bt362226AApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(Gr011Bt362226AApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(Gr011Bt362226AApplication.class, args);
    }

}
