package com.example.gr01_1bt3_622_26a.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.messageresolver.StandardMessageResolver;
import org.thymeleaf.spring6.SpringTemplateEngine;
import org.thymeleaf.spring6.templateresolver.SpringResourceTemplateResolver;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.ITemplateResolver;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Configuración de Web MVC con dual-mode:
 * 1. JSP ViewResolver: Para todas las vistas web desde src/main/webapp/WEB-INF/jsp/
 * 2. Thymeleaf TemplateEngine: Para renderizado de plantillas HTML en generación de PDFs
 *    (NO se usa como ViewResolver, evitando auto-configuración problemática)
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        // Configura el ViewResolver ÚNICO para JSP - todas las vistas web usan JSP
        registry.jsp("/WEB-INF/jsp/", ".jsp");
    }

    /**
     * Bean de TemplateEngine para uso manual en ContratoService
     * Busca plantillas en classpath:/templates/ para generación de PDFs
     */
    @Bean
    public TemplateEngine pdfTemplateEngine() {
        SpringTemplateEngine engine = new SpringTemplateEngine();
        engine.setTemplateResolver(pdfTemplateResolver());
        engine.setMessageResolver(new StandardMessageResolver());
        return engine;
    }

    /**
     * Resolvedor de plantillas para PDFs desde classpath
     */
    private ITemplateResolver pdfTemplateResolver() {
        SpringResourceTemplateResolver resolver = new SpringResourceTemplateResolver();
        resolver.setPrefix("classpath:/templates/");
        resolver.setSuffix(".html");
        resolver.setTemplateMode(TemplateMode.HTML);
        resolver.setCacheable(true);
        resolver.setCharacterEncoding("UTF-8");
        return resolver;
    }
}


