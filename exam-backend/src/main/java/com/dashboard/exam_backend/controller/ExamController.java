package com.dashboard.exam_backend.controller;

import com.dashboard.exam_backend.model.CsvData;
import com.dashboard.exam_backend.model.TestResult;
import com.dashboard.exam_backend.service.CsvService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class ExamController {

    private final CsvService csvService;

    public ExamController(CsvService csvService) {
        this.csvService = csvService;
    }

    // 🔹 Test API
    @GetMapping("/test")
    @ResponseBody
    public String test() {
        return "API is working";
    }

    // 🔹 Dashboard
    @GetMapping("/")
    public String dashboard(
            @RequestParam(required = false) String eventId,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate,
            Model model
    ) throws JsonProcessingException {

        CsvData csvData = csvService.readCsv();
        List<TestResult> allResults = csvData.getResults();
        List<String> eventList = csvData.getEventIds();

        // ==========================
        // 🎯 Selected Event
        // ==========================
        final String selectedEventId =
                (eventId == null || eventId.isBlank()) ? null : eventId;

        List<TestResult> filteredResults = allResults.stream()
                .filter(r -> r.getEventId() != null)
                .filter(r -> selectedEventId == null ||
                             r.getEventId().equalsIgnoreCase(selectedEventId))
                .collect(Collectors.toList());

        // ==========================
        // 🌍 Country Map Data
        // ==========================
        Map<String, Long> countryData = filteredResults.stream()
                .filter(r -> r.getCountryCode() != null && !r.getCountryCode().isBlank())
                .collect(Collectors.groupingBy(
                        TestResult::getCountryCode,
                        Collectors.counting()
                ));

        // ==========================
        // 📅 DATE FORMATTERS
        // ==========================
        DateTimeFormatter uiFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd"); // HTML input
        DateTimeFormatter csvFormatter = DateTimeFormatter.ofPattern("dd-MM-yyyy"); // CSV dates

        LocalDate start = (startDate == null || startDate.isBlank())
                ? LocalDate.now().minusDays(30)
                : LocalDate.parse(startDate, uiFormatter);

        LocalDate end = (endDate == null || endDate.isBlank())
                ? LocalDate.now()
                : LocalDate.parse(endDate, uiFormatter);

        // ==========================
        // 📈 GROUP BOOKINGS BY DATE
        // ==========================
        Map<LocalDate, Long> bookingTrend = filteredResults.stream()
                .filter(r -> r.getExamDate() != null && !r.getExamDate().isBlank())
                .map(r -> LocalDate.parse(r.getExamDate(), csvFormatter)) // ✅ FIX HERE
                .filter(d -> !d.isBefore(start) && !d.isAfter(end))
                .collect(Collectors.groupingBy(
                        d -> d,
                        Collectors.counting()
                ));

        // ==========================
        // 🔄 Fill Missing Dates
        // ==========================
        Map<String, Long> sortedTrend = new LinkedHashMap<>();
        for (LocalDate d = start; !d.isAfter(end); d = d.plusDays(1)) {
            sortedTrend.put(d.toString(), bookingTrend.getOrDefault(d, 0L));
        }
        
        
     // ==========================
     // 🏆 TOP 10 COUNTRIES BY BOOKINGS
     // ==========================
     Map<String, Long> top10Countries = filteredResults.stream()
             .filter(r -> r.getCountryCode() != null && !r.getCountryCode().isBlank())
             .collect(Collectors.groupingBy(
                     TestResult::getCountryCode,
                     Collectors.counting()
             ))
             .entrySet()
             .stream()
             .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
             .limit(10)
             .collect(Collectors.toMap(
                     Map.Entry::getKey,
                     Map.Entry::getValue,
                     (a, b) -> a,
                     LinkedHashMap::new
             ));

     // ==========================
     // 📋 TOP 10 COUNTRIES TABLE DATA
     // ==========================
     List<Map<String, Object>> top10CountryTable = new ArrayList<>();

     for (Map.Entry<String, Long> entry : top10Countries.entrySet()) {
         Map<String, Object> row = new HashMap<>();
         row.put("eventId", selectedEventId);
         row.put("country", entry.getKey());
         row.put("bookings", entry.getValue());
         top10CountryTable.add(row);
     }



        // ==========================
        // 📦 JSON Conversion
        // ==========================
        ObjectMapper mapper = new ObjectMapper();

        model.addAttribute("eventList", eventList);
        model.addAttribute("eventId", selectedEventId);
        model.addAttribute("eventBookings", filteredResults.size());
        model.addAttribute("totalEvents", eventList.size());

        model.addAttribute("countryDataJson", mapper.writeValueAsString(countryData));
        model.addAttribute("bookingTrendJson", mapper.writeValueAsString(sortedTrend));

        model.addAttribute("startDate", start.toString());
        model.addAttribute("endDate", end.toString());
        model.addAttribute("top10CountryTable", top10CountryTable);


        return "dashboard";
    }
}
