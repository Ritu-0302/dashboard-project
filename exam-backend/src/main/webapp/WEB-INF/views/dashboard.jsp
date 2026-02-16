<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Exam Dashboard</title>

     <!-- Bootstrap -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    
    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
          integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
          crossorigin=""/>

    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
            integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
            crossorigin=""></script>

</head>
<style> 
body {
    background-color: #f5f7fa;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}

.dashboard-container {
    padding: 20px;
    max-width: 1600px;
    margin: 0 auto;
}

.dashboard-header {
    background: white;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    margin-bottom: 25px;
}


.dashboard-title {
    font-size: 28px;
    font-weight: 700;
    color: #2d3748;
    margin: 0;
}

.filter-section {
    background: white;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    margin-bottom: 25px;
}

.filter-header {
    font-size: 16px;
    font-weight: 600;
    color: #2d3748;
    margin-bottom: 20px;
}

.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
    gap: 20px;
    margin-bottom: 25px;
}

.stat-card {
    background: white;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    position: relative;
    overflow: hidden;
}

.stat-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 4px;
    height: 100%;
    background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
}

.stat-label {
    font-size: 13px;
    color: #718096;
    text-transform: uppercase;
    font-weight: 600;
    letter-spacing: 0.5px;
    margin-bottom: 10px;
}

.stat-value {
    font-size: 36px;
    font-weight: 700;
    color: #2d3748;
}

.chart-grid {
    display: grid;
    grid-template-columns: repeat(12, 1fr);
    gap: 20px;
    margin-bottom: 20px;
}

.chart-card {
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    padding: 25px;
    position: relative;
}

.chart-card.col-span-4 {
    grid-column: span 4;
}

.chart-card.col-span-5 {
    grid-column: span 5;
}

.chart-card.col-span-6 {
    grid-column: span 6;
}

.chart-card.col-span-7 {
    grid-column: span 7;
}

.chart-card.col-span-8 {
    grid-column: span 8;
}

.chart-card.col-span-12 {
    grid-column: span 12;
}

.chart-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 2px solid #f0f0f0;
}

.chart-title {
    font-size: 16px;
    font-weight: 600;
    color: #2d3748;
}

.chart-subtitle {
    font-size: 12px;
    color: #718096;
    margin-top: 4px;
}

.chart-body {
    position: relative;
}

/* Custom Event Search/Select Dropdown */
.event-search-wrapper {
    position: relative;
}

.event-search-input {
    width: 100%;
    padding: 10px 40px 10px 14px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-size: 14px;
    outline: none;
    cursor: pointer;
}

.event-search-input:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.dropdown-arrow {
    position: absolute;
    right: 14px;
    top: 50%;
    transform: translateY(-50%);
    pointer-events: none;
    color: #718096;
}

.event-dropdown {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    background: white;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    max-height: 250px;
    overflow-y: auto;
    display: none;
    z-index: 1000;
    margin-top: 5px;
}

.event-dropdown.show {
    display: block;
}

.event-option {
    padding: 10px 14px;
    cursor: pointer;
    font-size: 14px;
    color: #2d3748;
    transition: background 0.2s;
}

.event-option:hover {
    background-color: #f7fafc;
}

.event-option.selected {
    background-color: #667eea;
    color: white;
}

.event-option.hidden {
    display: none;
}

/* Modal Styles */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.6);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 9999;
    animation: fadeIn 0.2s;
}

.modal-overlay.show {
    display: flex;
}

.modal-content {
    background: white;
    border-radius: 16px;
    padding: 30px;
    max-width: 700px;
    width: 90%;
    max-height: 80vh;
    overflow-y: auto;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    animation: slideUp 0.3s;
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes slideUp {
    from { 
        transform: translateY(50px);
        opacity: 0;
    }
    to { 
        transform: translateY(0);
        opacity: 1;
    }
}

.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
    padding-bottom: 15px;
    border-bottom: 2px solid #f0f0f0;
}

.modal-title {
    font-size: 22px;
    font-weight: 700;
    color: #2d3748;
}

.modal-close {
    background: none;
    border: none;
    font-size: 28px;
    color: #718096;
    cursor: pointer;
    padding: 0;
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 6px;
    transition: all 0.2s;
}

.modal-close:hover {
    background: #f7fafc;
    color: #2d3748;
}

.modal-body {
    padding: 10px 0;
}

.others-badge {
    background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
    color: white;
    padding: 4px 10px;
    border-radius: 12px;
    font-size: 11px;
    font-weight: 600;
    cursor: pointer;
    display: inline-block;
    transition: all 0.2s;
    margin-left: 8px;
}

.others-badge:hover {
    transform: scale(1.05);
    box-shadow: 0 4px 12px rgba(240, 147, 251, 0.4);
}

/* Map Styles */
#worldMapContainer {
    width: 100%;
    height: 450px;
    background: #f8fafc;
    border-radius: 8px;
    position: relative;
    overflow: hidden;
}

#worldMap {
    height: 450px;
    width: 100%;
    border-radius: 8px;
    z-index: 1;
}

.leaflet-container {
    z-index: 1;
}

.leaflet-tooltip {
    font-size: 13px;
    padding: 8px 12px;
    background: rgba(0,0,0,0.85);
    color: white;
    border: none;
    border-radius: 6px;
}

/* Search Box in Header */
.search-box-header input {
    padding: 10px 15px;
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-size: 14px;
    outline: none;
    width: 250px;
    background: white;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    transition: all 0.2s;
}

.search-box-header input:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

/* Legend Below Map */
.map-legend-below {
    background: white;
    padding: 15px 20px;
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    font-size: 12px;
    margin-top: 20px;
}

.legend-items {
    display: flex;
    gap: 15px;
    flex-wrap: wrap;
    justify-content: center;
}

.map-legend-item {
    display: flex;
    align-items: center;
    gap: 8px;
}

.map-legend-color {
    width: 24px;
    height: 16px;
    border-radius: 3px;
    flex-shrink: 0;
}

.table-container {
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    overflow: hidden;
}
                            
.dashboard-table {
    width: 100%;
    border-collapse: collapse;
}

.dashboard-table thead {
    background-color: #f7fafc;
}

.dashboard-table th {
    padding: 14px 18px;
    text-align: left;
    font-size: 12px;
    font-weight: 600;
    color: #4a5568;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    border-bottom: 2px solid #e2e8f0;
}

.dashboard-table td {
    padding: 14px 18px;
    font-size: 14px;
    color: #2d3748;
    border-bottom: 1px solid #f0f0f0;
}

.dashboard-table tbody tr:hover {
    background-color: #f7fafc;
}

.form-select, .form-control {
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    font-size: 14px;
    padding: 10px 14px;
}

.form-select:focus, .form-control:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    outline: none;
}

.btn-primary {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    padding: 10px 24px;
    font-size: 14px;
    font-weight: 500;
    border-radius: 8px;
    transition: all 0.2s;
}

.btn-primary:hover {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
}

.alert {
    border-radius: 8px;
    padding: 12px 16px;
    margin-bottom: 20px;
}

.alert-danger {
    background-color: #fee;
    border: 1px solid #fcc;
    color: #c33;
}

.no-data-message {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100%;
    color: #718096;
    font-size: 16px;
    flex-direction: column;
    gap: 10px;
}

.no-data-icon {
    font-size: 48px;
    opacity: 0.5;
}

/* Responsive */
@media (max-width: 1200px) {
    .chart-card.col-span-4,
    .chart-card.col-span-5,
    .chart-card.col-span-7,
    .chart-card.col-span-8 {
        grid-column: span 12;
    }
    
    .chart-card.col-span-6 {
        grid-column: span 12;
    }
}

@media (max-width: 768px) {
    .legend-items {
        justify-content: center;
    }
    
    .search-box-header input {
        width: 200px;
    }
    
    .chart-header {
        flex-direction: column;
        align-items: flex-start;
        gap: 15px;
    }
}

</style>

<body>
<div class="dashboard-container">

    <!-- ================= HEADER ================= -->
    <div class="dashboard-header">
        <h1 class="dashboard-title">Exam Dashboard</h1>
    </div>

    <!-- ================= FILTERS ================= -->
    <div class="filter-section">
        <!-- <div class="filter-header">
            🔍 Filters
        </div> -->
        
        <form method="get" action="/dashboard" id="filterForm">
            <div class="row g-3 align-items-end">
                
                <!-- Custom Event Search & Select -->
                <div class="col-md-4">
                    <label class="form-label small text-muted fw-semibold">Search & Select Event ID (${totalEvents})</label>
                    <div class="event-search-wrapper">
                        <input type="text" 
                               id="eventSearchInput" 
                               class="event-search-input"
                               placeholder="Search or select Event ID..."
                               value="${eventId}"
                               autocomplete="off">
                        <span class="dropdown-arrow">▼</span>
                        
                        <div class="event-dropdown" id="eventDropdown">
                            <div class="event-option" data-value="">All Events</div>
                            <c:forEach var="e" items="${eventList}">
                                <div class="event-option" data-value="${e}">${e}</div>
                            </c:forEach>
                        </div>
                        
                        <input type="hidden" name="eventId" id="eventIdHidden" value="${eventId}">
                    </div>
                </div>

                <!-- Date Range Filter -->
                <div class="col-md-3">
                    <label class="form-label small text-muted fw-semibold">From Date</label>
                    <input type="date"
                           name="fromDate"
                           id="fromDate"
                           value="${fromDate}"
                           class="form-control"/>
                </div>
                
                <div class="col-md-3">
                    <label class="form-label small text-muted fw-semibold">To Date</label>
                    <input type="date"
                           name="toDate"
                           id="toDate"
                           value="${toDate}"
                           class="form-control"/>
                </div>
                
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">
                        Apply Filters
                    </button>
                </div>
            </div>
            
            <!-- Date validation error message -->
            <div id="dateError" class="alert alert-danger mt-3" style="display: none;">
                ⚠️ Date range cannot exceed 1 month (31 days). Please select a shorter period.
            </div>
        </form>
    </div>

    <!-- ================= STATS CARDS ================= -->
    <div class="stats-grid">
        <%-- <div class="stat-card">
            <div class="stat-label">Total Events</div>
            <div class="stat-value">${totalEvents}</div>
        </div>
 --%>
        <%-- <div class="stat-card">
            <div class="stat-label">
                <c:choose>
                    <c:when test="${empty eventId}">All Events Bookings</c:when>
                    <c:otherwise>${eventId} Bookings</c:otherwise>
                </c:choose>
            </div>
            <div class="stat-value" style="color: #667eea;">${eventBookings}</div>
        </div> --%>
        
        <c:if test="${not empty fromDate and not empty toDate}">
            <div class="stat-card">
                <div class="stat-label">Selected Date Range</div>
                <div class="stat-value" style="font-size: 18px; color: #4a5568;">
                    ${fromDate}<br><small>to</small><br>${toDate}
                </div>
            </div>
        </c:if>
    </div>

    <!-- ================= CHARTS GRID ================= -->
    <div class="chart-grid">
        
        <!-- Line Chart - Booking Trend -->
        <div class="chart-card col-span-6">
            <div class="chart-header">
                <div>
                    <div class="chart-title">Booking Trend Over Time</div>
                    <div class="chart-subtitle">
                        <c:choose>
                            <c:when test="${empty eventId}">All Events(${eventBookings})</c:when>
                            <c:otherwise>${eventId} (${eventBookings})</c:otherwise>
                        </c:choose>
                        <c:if test="${not empty fromDate and not empty toDate}">
                            • ${fromDate} to ${toDate}
                        </c:if>
                    </div>
                </div>
            </div>
            <div class="chart-body" style="height: 300px;">
                <canvas id="bookingTrendChart"></canvas>
            </div>
        </div>

        <!-- Bar Chart - Country Distribution with Others -->
        <div class="chart-card col-span-6">
            <div class="chart-header">
                <div>
                    <div class="chart-title">
                         Top Countries by Bookings
                        <span class="others-badge" id="othersButton" style="display: none;">
                            + Others
                        </span>
                    </div>
                    <div class="chart-subtitle">
                        <c:choose>
                            <c:when test="${empty eventId}">All Events (${eventBookings})</c:when>
                            <c:otherwise>${eventId} (${eventBookings})</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            <div class="chart-body" style="height: 300px;">
                <canvas id="countryChart"></canvas>
            </div>
        </div>

       <!-- World Map -->
        <div class="chart-card col-span-8">
          <div class="chart-header">
            <div>
              <div class="chart-title">Global Booking Distribution</div>
              <div class="chart-subtitle">
                <c:choose>
                  <c:when test="${empty eventId}">All Events (${eventBookings})</c:when>
                  <c:otherwise>${eventId} (${eventBookings})</c:otherwise>
                  
                </c:choose>
              </div>
            </div>
            
            <!-- Search Box in Header -->
            <div class="search-box-header">
              <input type="text" 
                     id="countrySearch" 
                     placeholder="Search country..." 
                     autocomplete="off">
            </div>
          </div>

          <div class="chart-body">
            <div id="worldMapContainer">
              <div id="worldMap"></div>
            </div>

            <!-- Legend Below Map -->
            <div class="map-legend-below">
              <div style="font-weight: 600; margin-bottom: 10px; color: #2d3748; text-align: center;">Bookings</div>
              <div class="legend-items">
                <div class="map-legend-item">
                  <div class="map-legend-color" style="background: #1e3a8a;"></div>
                  <span>800+</span>
                </div>
                <div class="map-legend-item">
                  <div class="map-legend-color" style="background: #3b82f6;"></div>
                  <span>400–800</span>
                </div>
                <div class="map-legend-item">
                  <div class="map-legend-color" style="background: #60a5fa;"></div>
                  <span>100–400</span>
                </div>
                <div class="map-legend-item">
                  <div class="map-legend-color" style="background: #93c5fd;"></div>
                  <span>1–100</span>
                </div>
                <div class="map-legend-item">
                  <div class="map-legend-color" style="background: #e0e7ff;"></div>
                  <span>No data</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Top 10 Countries Table -->
        <div class="chart-card col-span-4">
            <div class="chart-header">
                <div>
                    <div class="chart-title">Top Countries</div>
                    <div class="chart-subtitle">Highest Bookings</div>
                </div>
            </div>
            <div class="chart-body" style="max-height: 450px; overflow-y: auto;">
                <table class="dashboard-table">
                    <thead>
                        <tr>
                            <th>Event ID</th>
                            <th>Country</th>
                            <th>Bookings</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="row" items="${top10CountryTable}">
                            <tr>
                                <td>${row.eventId}</td>
                                <td>${row.country}</td>
                                <td><strong style="color: #667eea;">${row.bookings}</strong></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</div>

<!-- Others Modal -->
<div class="modal-overlay" id="othersModal">
    <div class="modal-content">
        <div class="modal-header">
            <div>
                <div class="modal-title">Other Countries</div>
                <div style="font-size: 14px; color: #718096; margin-top: 5px;">
                    Remaining countries distribution
                </div>
            </div>
            <button class="modal-close" id="closeModal">&times;</button>
        </div>
        <div class="modal-body">
            <div style="height: 400px; position: relative;">
                <canvas id="othersPieChart"></canvas>
            </div>
            
            <!-- Others Countries List -->
            <div style="margin-top: 25px; max-height: 300px; overflow-y: auto;">
               <!--  <table class="dashboard-table">
                    <thead>
                        <tr>
                            <th>Country</th>
                            <th>Bookings</th>
                            <th>Percentage</th>
                        </tr>
                    </thead>
                    <tbody id="othersTableBody">
                    </tbody>
                </table> -->
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {

  /* ================= CUSTOM EVENT SEARCH/SELECT DROPDOWN ================= */
  const eventSearchInput = document.getElementById('eventSearchInput');
  const eventDropdown = document.getElementById('eventDropdown');
  const eventIdHidden = document.getElementById('eventIdHidden');
  const eventOptions = eventDropdown.querySelectorAll('.event-option');

  eventSearchInput.addEventListener('click', function(e) {
    e.stopPropagation();
    eventDropdown.classList.toggle('show');
  });

  eventSearchInput.addEventListener('input', function() {
    const searchTerm = this.value.toLowerCase();
    
    eventOptions.forEach(option => {
      const optionText = option.textContent.toLowerCase();
      if (optionText.includes(searchTerm)) {
        option.classList.remove('hidden');
      } else {
        option.classList.add('hidden');
      }
    });
    
    eventDropdown.classList.add('show');
  });

  eventOptions.forEach(option => {
    if (option.dataset.value === eventIdHidden.value) {
      option.classList.add('selected');
    }
    
    option.addEventListener('click', function(e) {
      e.stopPropagation();
      
      eventSearchInput.value = this.textContent;
      eventIdHidden.value = this.dataset.value;
      
      eventOptions.forEach(opt => opt.classList.remove('selected'));
      this.classList.add('selected');
      
      eventDropdown.classList.remove('show');
    });
  });

  document.addEventListener('click', function() {
    eventDropdown.classList.remove('show');
  });

  /* ================= DATE VALIDATION (MAX 1 MONTH) ================= */
  const filterForm = document.getElementById('filterForm');
  const fromDateInput = document.getElementById('fromDate');
  const toDateInput = document.getElementById('toDate');
  const dateError = document.getElementById('dateError');

  filterForm.addEventListener('submit', function(e) {
    const fromDate = new Date(fromDateInput.value);
    const toDate = new Date(toDateInput.value);
    
    if (fromDateInput.value && toDateInput.value) {
      const diffTime = Math.abs(toDate - fromDate);
      const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
      
      if (diffDays > 31) {
        e.preventDefault();
        dateError.style.display = 'block';
        dateError.scrollIntoView({ behavior: 'smooth', block: 'center' });
        return false;
      } else {
        dateError.style.display = 'none';
      }
    }
  });

  fromDateInput.addEventListener('change', function() {
    dateError.style.display = 'none';
  });
  
  toDateInput.addEventListener('change', function() {
    dateError.style.display = 'none';
  });

  /* ================= BACKEND DATA ================= */
  const countryDataMap = ${countryDataJson != null ? countryDataJson : '{}'};
  const trendData = ${bookingTrendJson != null ? bookingTrendJson : '{}'};

  console.log("=== DASHBOARD DATA ===");
  console.log("Country Data:", countryDataMap);
  console.log("Trend Data:", trendData);

  /* =================================================
     LINE CHART - Booking Trend (FIXED: Only show if data exists)
     ================================================= */
  const trendLabels = Object.keys(trendData);
  const trendValues = Object.values(trendData);
  
  // Check if there's any actual data
  const hasData = trendLabels.length > 0 && trendValues.some(v => v > 0);
  
  if (hasData) {
    new Chart(document.getElementById("bookingTrendChart"), {
      type: "line",
      data: {
        labels: trendLabels,
        datasets: [{
          label: 'Bookings',
          data: trendValues,
          borderColor: "#667eea",
          backgroundColor: "rgba(102, 126, 234, 0.1)",
          fill: true,
          tension: 0.4,
          borderWidth: 3,
          pointRadius: 4,
          pointBackgroundColor: "#667eea",
          pointBorderColor: "#fff",
          pointBorderWidth: 2,
          pointHoverRadius: 6
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: { 
          legend: { display: false },
          tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            titleColor: '#fff',
            bodyColor: '#fff',
            borderColor: '#667eea',
            borderWidth: 1,
            displayColors: false,
            callbacks: {
              label: function(context) {
                return 'Bookings: ' + context.parsed.y;
              }
            }
          }
        },
        scales: { 
          y: { 
            beginAtZero: true,
            grid: { color: '#f0f0f0' },
            ticks: { color: '#718096', font: { size: 11 } }
          },
          x: {
            grid: { display: false },
            ticks: { color: '#718096', font: { size: 11 }, maxRotation: 45, minRotation: 0 }
          }
        }
      }
    });
  } else {
    // Show "No data" message
    document.getElementById("bookingTrendChart").parentElement.innerHTML = 
      '<div class="no-data-message">' +
      '<div class="no-data-icon">📊</div>' +
      '<div>No booking data available for selected period</div>' +
      '</div>';
  }

  /* =================================================
     BAR CHART - Country Distribution with "Others"
     ================================================= */
  const countryLabels = Object.keys(countryDataMap);
  const countryValues = Object.values(countryDataMap);
  
  // Sort and separate top 11 and others
  const sortedCountries = countryLabels
    .map((label, index) => ({ label, value: countryValues[index] }))
    .sort((a, b) => b.value - a.value);
  
  const topCountries = sortedCountries.slice(0, 11);
  const otherCountries = sortedCountries.slice(11);
  
  // Calculate "Others" total
  const othersTotal = otherCountries.reduce((sum, c) => sum + c.value, 0);
  
  // Prepare chart data
  const chartLabels = topCountries.map(c => c.label);
  const chartValues = topCountries.map(c => c.value);
  
  // Add "Others" if there are remaining countries
  if (otherCountries.length > 0) {
    chartLabels.push('Others');
    chartValues.push(othersTotal);
    
    // Show the "Others" badge button
    document.getElementById('othersButton').style.display = 'inline-block';
  }

  new Chart(document.getElementById("countryChart"), {
    type: "bar",
    data: {
      labels: chartLabels,
      datasets: [{
        label: 'Bookings',
        data: chartValues,
        backgroundColor: chartLabels.map((label, index) => 
          label === 'Others' ? '#f5576c' : '#667eea'
        ),
        borderRadius: 6,
        maxBarThickness: 30,
        barPercentage: 0.6,
        categoryPercentage: 0.7
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      indexAxis: 'y',
      onClick: function(evt, elements) {
        if (elements.length > 0) {
          const index = elements[0].index;
          const label = chartLabels[index];
          
          if (label === 'Others') {
            showOthersModal();
          }
        }
      },
      plugins: { 
        legend: { display: false },
        tooltip: {
          backgroundColor: 'rgba(0, 0, 0, 0.8)',
          padding: 12,
          titleColor: '#fff',
          bodyColor: '#fff',
          borderColor: '#667eea',
          borderWidth: 1,
          displayColors: false,
          callbacks: {
            label: function(context) {
              const label = context.label;
              const value = context.parsed.x;
              if (label === 'Others') {
                return 'Others (' + otherCountries.length + ' countries): ' + value + ' bookings';
              }
              return 'Bookings: ' + value;
            }
          }
        }
      },
      scales: { 
        x: { 
          beginAtZero: true,
          grid: { color: '#f0f0f0' },
          ticks: { color: '#718096', font: { size: 11 } }
        },
        y: {
          grid: { display: false },
          ticks: { color: '#718096', font: { size: 11 } }
        }
      }
    }
  });

  /* =================================================
     OTHERS MODAL WITH PIE CHART
     ================================================= */
  let othersPieChartInstance = null;

  function showOthersModal() {
    const modal = document.getElementById('othersModal');
    modal.classList.add('show');
    
    // Calculate percentages
    const othersWithPercentage = otherCountries.map(c => ({
      ...c,
      percentage: ((c.value / othersTotal) * 100).toFixed(1)
    }));
    
    // Create pie chart
    const ctx = document.getElementById('othersPieChart').getContext('2d');
    
    // Destroy previous chart if exists
    if (othersPieChartInstance) {
      othersPieChartInstance.destroy();
    }
    
    // Generate colors for pie chart
    const colors = [
      '#667eea', '#764ba2', '#f093fb', '#f5576c', '#4facfe', 
      '#00f2fe', '#43e97b', '#38f9d7', '#fa709a', '#fee140',
      '#30cfd0', '#330867', '#a8edea', '#fed6e3', '#ff9a9e'
    ];
    
    othersPieChartInstance = new Chart(ctx, {
      type: 'pie',
      data: {
        labels: otherCountries.map(c => c.label),
        datasets: [{
          data: otherCountries.map(c => c.value),
          backgroundColor: colors.slice(0, otherCountries.length),
          borderWidth: 2,
          borderColor: '#fff'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'right',
            labels: {
              padding: 15,
              font: { size: 11 },
              generateLabels: function(chart) {
                const data = chart.data;
                return data.labels.map((label, i) => ({
                  text: label + ' (' + data.datasets[0].data[i] + ')',
                  fillStyle: data.datasets[0].backgroundColor[i],
                  hidden: false,
                  index: i
                }));
              }
            }
          },
          tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            callbacks: {
              label: function(context) {
                const label = context.label;
                const value = context.parsed;
                const percentage = ((value / othersTotal) * 100).toFixed(1);
                return label + ': ' + value + ' bookings (' + percentage + '%)';
              }
            }
          }
        }
      }
    });
    
    // Populate table
    const tableBody = document.getElementById('othersTableBody');
    tableBody.innerHTML = '';
    
    othersWithPercentage.forEach(country => {
      const row = document.createElement('tr');
      row.innerHTML = `
        <td>${country.label}</td>
        <td><strong style="color: #667eea;">${country.value}</strong></td>
        <td>${country.percentage}%</td>
      `;
      tableBody.appendChild(row);
    });
  }

  // Close modal
  document.getElementById('closeModal').addEventListener('click', function() {
    document.getElementById('othersModal').classList.remove('show');
  });
  
  document.getElementById('othersButton').addEventListener('click', function() {
    showOthersModal();
  });
  
  document.getElementById('othersModal').addEventListener('click', function(e) {
    if (e.target === this) {
      this.classList.remove('show');
    }
  });

  /* =================================================
     LEAFLET WORLD MAP
     ================================================= */
  
  const bookingsByIso2 = {};
  const bookingsByName = {};
  
  const isoMapping = {
		  'AF': ['AF','AFG','AFGHANISTAN'],
		  'AL': ['AL','ALB','ALBANIA'],
		  'DZ': ['DZ','DZA','ALGERIA'],
		  'AD': ['AD','AND','ANDORRA'],
		  'AO': ['AO','AGO','ANGOLA'],
		  'AR': ['AR','ARG','ARGENTINA'],
		  'AM': ['AM','ARM','ARMENIA'],
		  'AU': ['AU','AUS','AUSTRALIA'],
		  'AT': ['AT','AUT','AUSTRIA'],
		  'AZ': ['AZ','AZE','AZERBAIJAN'],
		  'BH': ['BH','BHR','BAHRAIN'],
		  'BD': ['BD','BGD','BANGLADESH'],
		  'BY': ['BY','BLR','BELARUS'],
		  'BE': ['BE','BEL','BELGIUM'],
		  'BZ': ['BZ','BLZ','BELIZE'],
		  'BJ': ['BJ','BEN','BENIN'],
		  'BT': ['BT','BTN','BHUTAN'],
		  'BO': ['BO','BOL','BOLIVIA'],
		  'BA': ['BA','BIH','BOSNIA AND HERZEGOVINA'],
		  'BW': ['BW','BWA','BOTSWANA'],
		  'BR': ['BR','BRA','BRAZIL'],
		  'BN': ['BN','BRN','BRUNEI'],
		  'BG': ['BG','BGR','BULGARIA'],
		  'BF': ['BF','BFA','BURKINA FASO'],
		  'BI': ['BI','BDI','BURUNDI'],
		  'KH': ['KH','KHM','CAMBODIA'],
		  'CM': ['CM','CMR','CAMEROON'],
		  'CA': ['CA','CAN','CANADA'],
		  'CV': ['CV','CPV','CAPE VERDE'],
		  'CF': ['CF','CAF','CENTRAL AFRICAN REPUBLIC'],
		  'TD': ['TD','TCD','CHAD'],
		  'CL': ['CL','CHL','CHILE'],
		  'CN': ['CN','CHN','CHINA'],
		  'CO': ['CO','COL','COLOMBIA'],
		  'KM': ['KM','COM','COMOROS'],
		  'CG': ['CG','COG','CONGO'],
		  'CR': ['CR','CRI','COSTA RICA'],
		  'HR': ['HR','HRV','CROATIA'],
		  'CU': ['CU','CUB','CUBA'],
		  'CY': ['CY','CYP','CYPRUS'],
		  'CZ': ['CZ','CZE','CZECH REPUBLIC','CZECHIA'],
		  'DK': ['DK','DNK','DENMARK'],
		  'DJ': ['DJ','DJI','DJIBOUTI'],
		  'DO': ['DO','DOM','DOMINICAN REPUBLIC'],
		  'EC': ['EC','ECU','ECUADOR'],
		  'EG': ['EG','EGY','EGYPT'],
		  'SV': ['SV','SLV','EL SALVADOR'],
		  'EE': ['EE','EST','ESTONIA'],
		  'ET': ['ET','ETH','ETHIOPIA'],
		  'FI': ['FI','FIN','FINLAND'],
		  'FR': ['FR','FRA','FRANCE'],
		  'GA': ['GA','GAB','GABON'],
		  'GM': ['GM','GMB','GAMBIA'],
		  'GE': ['GE','GEO','GEORGIA'],
		  'DE': ['DE','DEU','GERMANY'],
		  'GH': ['GH','GHA','GHANA'],
		  'GR': ['GR','GRC','GREECE'],
		  'GT': ['GT','GTM','GUATEMALA'],
		  'GN': ['GN','GIN','GUINEA'],
		  'HT': ['HT','HTI','HAITI'],
		  'HN': ['HN','HND','HONDURAS'],
		  'HU': ['HU','HUN','HUNGARY'],
		  'IS': ['IS','ISL','ICELAND'],
		  'IN': ['IN','IND','INDIA'],
		  'ID': ['ID','IDN','INDONESIA'],
		  'IR': ['IR','IRN','IRAN'],
		  'IQ': ['IQ','IRQ','IRAQ'],
		  'IE': ['IE','IRL','IRELAND'],
		  'IL': ['IL','ISR','ISRAEL'],
		  'IT': ['IT','ITA','ITALY'],
		  'JM': ['JM','JAM','JAMAICA'],
		  'JP': ['JP','JPN','JAPAN'],
		  'JO': ['JO','JOR','JORDAN'],
		  'KZ': ['KZ','KAZ','KAZAKHSTAN'],
		  'KE': ['KE','KEN','KENYA'],
		  'KW': ['KW','KWT','KUWAIT'],
		  'KG': ['KG','KGZ','KYRGYZSTAN'],
		  'LA': ['LA','LAO','LAOS'],
		  'LV': ['LV','LVA','LATVIA'],
		  'LB': ['LB','LBN','LEBANON'],
		  'LS': ['LS','LSO','LESOTHO'],
		  'LR': ['LR','LBR','LIBERIA'],
		  'LY': ['LY','LBY','LIBYA'],
		  'LT': ['LT','LTU','LITHUANIA'],
		  'LU': ['LU','LUX','LUXEMBOURG'],
		  'MG': ['MG','MDG','MADAGASCAR'],
		  'MW': ['MW','MWI','MALAWI'],
		  'MY': ['MY','MYS','MALAYSIA'],
		  'MV': ['MV','MDV','MALDIVES'],
		  'ML': ['ML','MLI','MALI'],
		  'MT': ['MT','MLT','MALTA'],
		  'MX': ['MX','MEX','MEXICO'],
		  'MD': ['MD','MDA','MOLDOVA'],
		  'MC': ['MC','MCO','MONACO'],
		  'MN': ['MN','MNG','MONGOLIA'],
		  'ME': ['ME','MNE','MONTENEGRO'],
		  'MA': ['MA','MAR','MOROCCO'],
		  'MZ': ['MZ','MOZ','MOZAMBIQUE'],
		  'MM': ['MM','MMR','MYANMAR'],
		  'NA': ['NA','NAM','NAMIBIA'],
		  'NP': ['NP','NPL','NEPAL'],
		  'NL': ['NL','NLD','NETHERLANDS'],
		  'NZ': ['NZ','NZL','NEW ZEALAND'],
		  'NI': ['NI','NIC','NICARAGUA'],
		  'NE': ['NE','NER','NIGER'],
		  'NG': ['NG','NGA','NIGERIA'],
		  'KP': ['KP','PRK','NORTH KOREA'],
		  'NO': ['NO','NOR','NORWAY'],
		  'OM': ['OM','OMN','OMAN'],
		  'PK': ['PK','PAK','PAKISTAN'],
		  'PA': ['PA','PAN','PANAMA'],
		  'PY': ['PY','PRY','PARAGUAY'],
		  'PE': ['PE','PER','PERU'],
		  'PH': ['PH','PHL','PHILIPPINES'],
		  'PL': ['PL','POL','POLAND'],
		  'PT': ['PT','PRT','PORTUGAL'],
		  'QA': ['QA','QAT','QATAR'],
		  'RO': ['RO','ROU','ROMANIA'],
		  'RU': ['RU','RUS','RUSSIA','RUSSIAN FEDERATION'],
		  'SA': ['SA','SAU','SAUDI ARABIA'],
		  'RS': ['RS','SRB','SERBIA'],
		  'SG': ['SG','SGP','SINGAPORE'],
		  'SK': ['SK','SVK','SLOVAKIA'],
		  'SI': ['SI','SVN','SLOVENIA'],
		  'ZA': ['ZA','ZAF','SOUTH AFRICA'],
		  'KR': ['KR','KOR','SOUTH KOREA'],
		  'ES': ['ES','ESP','SPAIN'],
		  'LK': ['LK','LKA','SRI LANKA'],
		  'SE': ['SE','SWE','SWEDEN'],
		  'CH': ['CH','CHE','SWITZERLAND'],
		  'SY': ['SY','SYR','SYRIA'],
		  'TW': ['TW','TWN','TAIWAN'],
		  'TZ': ['TZ','TZA','TANZANIA'],
		  'TH': ['TH','THA','THAILAND'],
		  'TN': ['TN','TUN','TUNISIA'],
		  'TR': ['TR','TUR','TURKEY'],
		  'UG': ['UG','UGA','UGANDA'],
		  'UA': ['UA','UKR','UKRAINE'],
		  'AE': ['AE','ARE','UNITED ARAB EMIRATES','UAE'],
		  'GB': ['GB','GBR','UNITED KINGDOM','UK'],
		  'US': ['US','USA','UNITED STATES','UNITED STATES OF AMERICA'],
		  'UY': ['UY','URY','URUGUAY'],
		  'UZ': ['UZ','UZB','UZBEKISTAN'],
		  'VE': ['VE','VEN','VENEZUELA'],
		  'VN': ['VN','VNM','VIETNAM'],
		  'YE': ['YE','YEM','YEMEN'],
		  'ZM': ['ZM','ZMB','ZAMBIA'],
		  'ZW': ['ZW','ZWE','ZIMBABWE']

  };
  
  Object.keys(countryDataMap).forEach(function(k) {
    const upperKey = k.toUpperCase().trim();
    const value = countryDataMap[k];
    
    bookingsByIso2[upperKey] = value;
    bookingsByName[upperKey] = value;
    
    if (isoMapping[upperKey]) {
      isoMapping[upperKey].forEach(function(variant) {
        bookingsByIso2[variant.toUpperCase()] = value;
        bookingsByName[variant.toUpperCase()] = value;
      });
    }
  });

  const map = L.map("worldMap", {
    keyboard: false,
    minZoom: 2,
    maxZoom: 6,
    zoomControl: true
  }).setView([20, 0], 2.5);

  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution: "© OpenStreetMap",
    maxZoom: 6
  }).addTo(map);

  function getColor(v) {
    return v > 800 ? "#1e3a8a" :
           v > 400 ? "#3b82f6" :
           v > 100 ? "#60a5fa" :
           v > 0   ? "#93c5fd" :
                     "#e0e7ff";
  }

  let geojsonLayer;
  let selectedLayer = null;

  function style(feature) {
    const props = feature.properties;
    const iso2 = (props.ISO_A2 || props.iso_a2 || props.code || '').toUpperCase();
    const iso3 = (props.ISO_A3 || props.iso_a3 || '').toUpperCase();
    const name = (props.ADMIN || props.admin || props.name || props.NAME || '').toUpperCase();
    
    let bookings = bookingsByIso2[iso2] || 
                   bookingsByIso2[iso3] || 
                   bookingsByName[name] || 
                   bookingsByName[name.replace(/\s+/g, '')] || 
                   0;
    
    return {
      fillColor: getColor(bookings),
      weight: 1,
      color: "#cbd5e0",
      fillOpacity: 0.85
    };
  }

  function selectLayer(layer) {
    if (selectedLayer && geojsonLayer) {
      geojsonLayer.resetStyle(selectedLayer);
    }
    selectedLayer = layer;
    layer.setStyle({
      weight: 3,
      color: "#f97316",
      fillOpacity: 1
    });
    layer.bringToFront();
  }

  function onEachFeature(feature, layer) {
    const props = feature.properties;
    
    const iso2 = (props.ISO_A2 || props.iso_a2 || props.code || '').trim();
    const iso3 = (props.ISO_A3 || props.iso_a3 || '').trim();
    const name = (props.ADMIN || props.admin || props.name || props.NAME || 'Unknown').trim();
    const nameAlt = (props.NAME || props.name_long || props.formal_en || '').trim();
    
    let bookings = 0;
    
    if (iso2 && bookingsByIso2[iso2.toUpperCase()]) {
      bookings = bookingsByIso2[iso2.toUpperCase()];
    }
    else if (iso3 && bookingsByIso2[iso3.toUpperCase()]) {
      bookings = bookingsByIso2[iso3.toUpperCase()];
    }
    else if (name && bookingsByName[name.toUpperCase()]) {
      bookings = bookingsByName[name.toUpperCase()];
    }
    else if (nameAlt && bookingsByName[nameAlt.toUpperCase()]) {
      bookings = bookingsByName[nameAlt.toUpperCase()];
    }

    layer.bindTooltip(
      "<strong>" + name + "</strong><br>" +
      "<b>" + bookings + "</b> bookings",
      { sticky: true }
    );

    layer.on("click", function(e) {
      selectLayer(layer);
      map.fitBounds(layer.getBounds(), { maxZoom: 5 });

      L.popup()
        .setLatLng(e.latlng)
        .setContent(
          '<div style="text-align:center;min-width:140px">' +
            '<b>' + name + '</b><br>' +
            '<small>' + iso2 + '</small>' +
            '<div style="font-size:28px;font-weight:700;color:#667eea;margin:8px 0">' +
              bookings +
            '</div>' +
            '<small>Total Bookings</small>' +
          '</div>'
        )
        .openOn(map);
    });
  }

  fetch("https://raw.githubusercontent.com/datasets/geo-countries/master/data/countries.geojson")
    .then(r => r.json())
    .then(data => {
  geojsonLayer = L.geoJson(data, {
    style,
    onEachFeature
  }).addTo(map);

  // ✅ BUILD FAST SEARCH INDEX
  window.countryIndex = {};

  geojsonLayer.eachLayer(layer => {
    const props = layer.feature.properties;
    const name = (props.ADMIN || props.name || "").toLowerCase();
    const iso2 = (props.ISO_A2 || "").toLowerCase();

    if (name) window.countryIndex[name] = layer;
    if (iso2) window.countryIndex[iso2] = layer;
  });

  console.log("✅ Country index built", Object.keys(window.countryIndex).length);
})

    .catch(err => console.error("Map loading error:", err));

  // Country search functionality
  const searchInput = document.getElementById("countrySearch");
  if (searchInput) {
    let searchTimer = null;

    searchInput.addEventListener("input", function (e) {
      clearTimeout(searchTimer);

      const query = this.value.toLowerCase().trim();

      searchTimer = setTimeout(() => {

        if (!query) {
          map.setView([20, 0], 2.5);
          if (selectedLayer && geojsonLayer) {
            geojsonLayer.resetStyle(selectedLayer);
            selectedLayer = null;
          }
          return;
        }

        const layer =
          window.countryIndex[query] ||
          Object.keys(window.countryIndex).find(k => k.startsWith(query))
            ? window.countryIndex[
                Object.keys(window.countryIndex).find(k => k.startsWith(query))
              ]
            : null;

        if (layer) {
          selectLayer(layer);
          map.fitBounds(layer.getBounds(), { maxZoom: 5 });
        }

      }, 250); // debounce delay
    });
  }

});
</script>

</body>
</html>
