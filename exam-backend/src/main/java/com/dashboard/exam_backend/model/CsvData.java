package com.dashboard.exam_backend.model;

import java.util.List;

public class CsvData {
    private List<TestResult> results;
    private List<String> eventIds;

    public CsvData(List<TestResult> results, List<String> eventIds) {
        this.results = results;
        this.eventIds = eventIds;
    }

    public List<TestResult> getResults() {
        return results;
    }

    public List<String> getEventIds() {
        return eventIds;
    }
}

