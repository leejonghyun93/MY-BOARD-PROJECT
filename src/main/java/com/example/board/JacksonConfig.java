package com.example.board;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.converter.json.Jackson2ObjectMapperBuilder;

@Configuration
public class JacksonConfig {
    @Bean
    public Jackson2ObjectMapperBuilder jacksonObjectMapperBuilder() {
        return Jackson2ObjectMapperBuilder.json()
                .simpleDateFormat("yyyy-MM-dd HH:mm:ss");
    }
}