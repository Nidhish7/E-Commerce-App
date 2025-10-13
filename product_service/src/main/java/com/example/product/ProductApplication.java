package com.example.product;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@SpringBootApplication
@RestController
public class ProductApplication {

    @GetMapping("/")
    public Map<String, String> home() {
        return Map.of("message", "Product Service is running");
    }

    @GetMapping("/products")
    public List<Map<String, Object>> getProducts() {
        return List.of(
                Map.of("id", 1, "name", "Laptop", "price", 70000),
                Map.of("id", 2, "name", "Phone", "price", 35000)
        );
    }

    public static void main(String[] args) {
        SpringApplication.run(ProductApplication.class, args);
    }
}
