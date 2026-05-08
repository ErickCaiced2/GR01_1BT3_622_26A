package com.example.gr01_1bt3_622_26a.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * ⚙️ Configuración de Spring MVC
 *
 * Registra interceptadores:
 * - AuthInterceptor: Verificación de sesión y rol en cada request
 *
 * Se ejecuta automáticamente al iniciar Spring Boot
 */
@Configuration
@RequiredArgsConstructor
public class WebMvcConfiguration implements WebMvcConfigurer {

    private final AuthInterceptor authInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(authInterceptor)
                .addPathPatterns("/**")
                .excludePathPatterns(
                        "/static/**",
                        "/css/**",
                        "/js/**",
                        "/images/**",
                        "/actuator/**"
                );
    }
}

