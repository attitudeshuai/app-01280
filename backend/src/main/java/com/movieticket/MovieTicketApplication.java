package com.movieticket;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 电影票预订系统 - 主启动类
 */
@SpringBootApplication
@MapperScan("com.movieticket.mapper")
public class MovieTicketApplication {

    public static void main(String[] args) {
        SpringApplication.run(MovieTicketApplication.class, args);
        System.out.println("\n" +
            "╔═══════════════════════════════════════════════════════╗\n" +
            "║       🎬 电影票预订系统启动成功!                      ║\n" +
            "║  API文档: http://localhost:8080/doc.html              ║\n" +
            "║  健康检查: http://localhost:8080/actuator/health      ║\n" +
            "╚═══════════════════════════════════════════════════════╝\n"
        );
    }
}
