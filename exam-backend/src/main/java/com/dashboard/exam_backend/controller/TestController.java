package com.dashboard.exam_backend.controller;

import com.dashboard.exam_backend.model.TestResult;
import com.dashboard.exam_backend.service.CsvService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class TestController {

    private final CsvService csvService;

    public TestController(CsvService csvService) {
        this.csvService = csvService;
    }

    @GetMapping("/results")
    public List<TestResult> getResults() {
        return csvService.readCsv().getResults();  
    }

}
