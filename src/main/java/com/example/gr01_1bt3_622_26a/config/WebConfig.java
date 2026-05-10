package com.example.gr01_1bt3_622_26a.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.web.filter.CharacterEncodingFilter;
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
 * 3. CharacterEncodingFilter: Para soportar correctamente tildes y caracteres españoles (UTF-8)
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        // Configura el ViewResolver ÚNICO para JSP - todas las vistas web usan JSP
        registry.jsp("/WEB-INF/jsp/", ".jsp");
    }

    /**
     * Filtro de codificación de caracteres UTF-8 para soportar español (tildes, ñ)
     * Asegura que todas las peticiones y respuestas usen UTF-8
     * @ConditionalOnMissingBean: Solo se crea si Spring Boot no lo ha creado ya
     */
    @Bean
    @ConditionalOnMissingBean
    public FilterRegistrationBean<CharacterEncodingFilter> customCharacterEncodingFilter() {
        FilterRegistrationBean<CharacterEncodingFilter> bean = new FilterRegistrationBean<>();
        CharacterEncodingFilter filter = new CharacterEncodingFilter();
        filter.setEncoding("UTF-8");
        filter.setForceEncoding(true);
        bean.setFilter(filter);
        bean.addUrlPatterns("/*");
        bean.setOrder(1);
        return bean;
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


