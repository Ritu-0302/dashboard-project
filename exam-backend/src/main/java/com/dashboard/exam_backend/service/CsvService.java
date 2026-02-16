package com.dashboard.exam_backend.service;

import com.dashboard.exam_backend.model.CsvData;
import com.dashboard.exam_backend.model.TestResult;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.*;
import java.util.stream.Collectors;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;


@Service
public class CsvService {

	
	public CsvData readCsv() {
	    List<TestResult> results = new ArrayList<>();
	    Set<String> eventIdsSet = new HashSet<>();

	    try {
	        InputStream is = getClass()
	                .getClassLoader()
	                .getResourceAsStream("data/Test Details.csv");

	        if (is == null) {
	            throw new RuntimeException("CSV file not found in resources/data");
	        }

	        BufferedReader br = new BufferedReader(new InputStreamReader(is));
	        String line;

	        br.readLine(); // skip header

	        while ((line = br.readLine()) != null) {
	            String[] values = line.split(",", -1);
	            if (values.length < 7) continue;

	            TestResult tr = new TestResult();
	            tr.setUserPlace(clean(values[0]));
	            tr.setExamDate(clean(values[1]));
	            tr.setBookedTime(clean(values[2]));
	            tr.setEventId(clean(values[3]));
	            tr.setDateOfBooking(clean(values[4]));
	            tr.setExamDuration(clean(values[5]));
	            tr.setCountryCode(clean(values[6]));

	            results.add(tr);

	            if (values[3] != null && !values[3].isBlank()) {
	                eventIdsSet.add(clean(values[3])); 
	            }
	        }

	        br.close();

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    List<String> eventIds = eventIdsSet.stream()
	            .sorted() 
	            .collect(Collectors.toList());

	    return new CsvData(results, eventIds);
	}

    // 🔹 Clean string values
    private String clean(String value) {
        if (value == null) return null;
        return value.replace("\"", "").trim();
    }

    // 🔹 Count by country (ALL events)
    public Map<String, Long> countByCountry() {
        return readCsv().getResults().stream()
                .filter(r -> r.getCountryCode() != null && !r.getCountryCode().isEmpty())
                .collect(Collectors.groupingBy(
                        TestResult::getCountryCode,
                        Collectors.counting()
                ));
    }

    // 🔹 Count by country FOR ONE EVENT
    public Map<String, Long> countByCountryAndEvent(String eventId) {
        return readCsv().getResults().stream()
                .filter(r -> eventId.equalsIgnoreCase(r.getEventId()))
                .filter(r -> r.getCountryCode() != null && !r.getCountryCode().isEmpty())
                .collect(Collectors.groupingBy(
                        TestResult::getCountryCode,
                        Collectors.counting()
                ));
    }

    // 🔹 Get all TestResult for one eventId
    public List<TestResult> getByEventId(String eventId) {
        return readCsv().getResults().stream()
                .filter(r -> r.getEventId() != null && r.getEventId().equalsIgnoreCase(eventId))
                .collect(Collectors.toList());
    }

    // 🔹 Get all unique eventIds
    public List<String> getAllEventIds() {
        return readCsv().getResults().stream()
                .map(TestResult::getEventId)
                .filter(Objects::nonNull)          // remove nulls
                .filter(e -> !e.isBlank())          // remove blanks
                .distinct()                         // unique
                .sorted()                           // sorted order
                .collect(Collectors.toList());
    }
 // 📈 Get bookings grouped by DATE (for line chart)
 // 📈 Get bookings grouped by DATE (for line chart)
    public Map<String, Long> getBookingsByDate(
            String eventId,
            LocalDate from,
            LocalDate to) {

        // CSV date format: 14-01-2026
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd-MM-yyyy");

        // 1️⃣ Initialize all dates with 0
        Map<String, Long> result = new LinkedHashMap<>();
        for (LocalDate d = from; !d.isAfter(to); d = d.plusDays(1)) {
            result.put(d.toString(), 0L); // yyyy-MM-dd (good for frontend)
        }

        // 2️⃣ Filter + group CSV data
        readCsv().getResults().stream()
                .filter(r -> r.getEventId() != null)
                .filter(r -> r.getEventId().equalsIgnoreCase(eventId))
                .filter(r -> r.getExamDate() != null && !r.getExamDate().isBlank())
                .map(r -> LocalDate.parse(r.getExamDate(), formatter))
                .filter(d -> !d.isBefore(from) && !d.isAfter(to))
                .forEach(d ->
                        result.put(d.toString(), result.get(d.toString()) + 1)
                );

        return result;
    }


}
