<%@page import="java.util.List"%>
<%@page import="org.team.dto.ReservationDTO"%>
<%@page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang='en'>
  <head>
    <meta charset='utf-8' />
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.15/index.global.min.js'></script>
    <script
	src='https://cdn.jsdelivr.net/npm/@fullcalendar/core@6.1.15/locales/ko.global.js'></script>
    	    <style>
	    
			.fc-day-sun .fc-col-header-cell-cushion {
				color: red;
			}
			.fc-day-sat .fc-col-header-cell-cushion {
				color: blue;
			}
	    	
/* 	    	.fc-daygrid-day .fc-daygrid-day-number {	// �Ͽ���, ����� ����
	    		color: black;
	    	} */
	    		
	    	.fc-daygrid-day.fc-day-sun .fc-daygrid-day-number{ 		
	    		color: red;
	    	}
	    	.fc-daygrid-day.fc-day-sat .fc-daygrid-day-number{		
	    		color: blue;
	    	}
	    </style>
	<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=e1ec5378979a9f3ffe97d798bdcd05e1&libraries=services"></script>
    <script>

    var selectedEvent = null;
    var mouseX = undefined;
    var mouseY = undefined;
    
      document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');

        var jsonData = [
            <c:forEach var="board" items="${list}" varStatus="status">
                {
                    "title": "<c:out value="${board.cname}"/>",
                    "start": "<c:out value="${board.visitdate}"/>",
                    "end": "<c:out value="${board.visitdate_end}"/>",
                    "extendedProps": {
                    	"location": "<c:out value="${board.address}"/>" // DB���� ������ ��� ��
                    }
                }
                <c:if test="${!status.last}">,</c:if> <!-- ������ ��� �ڿ� ��ǥ�� ���ֱ� ���� ���� �߰� -->
            </c:forEach>
        ];
        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
        	locale: 'ko',
        
        	  eventSources: [

        		    // your event source
        		    {
        		      events: jsonData,
        		      
        		      color: 'black',     // an option!
        		      textColor: 'yellow' // an option!
        		    }

        		    // any other event sources...

        		  ],
                  eventClick: function(info) {
                      handleEventClick(info);
                  }

        		});

        calendar.render();
    });
      
   // īī�� ���� �ε� �Լ�
      function loadMap(location) {
          var mapContainer = document.getElementById('map');
          mapContainer.innerHTML = ''; // ���� ���� ���� �ʱ�ȭ

          var geocoder = new kakao.maps.services.Geocoder();
          var mapOption = {
              center: new kakao.maps.LatLng(33.450701, 126.570667), // �⺻ ��ġ
              level: 3
          };

          // ���� ��ü �̸� ����
          var map = new kakao.maps.Map(mapContainer, mapOption);

          // �ּ�-��ǥ ��ȯ�� ���� īī�� ���� API ȣ��
          geocoder.addressSearch(location, function(result, status) {
              if (status === kakao.maps.services.Status.OK) {
                  var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                  // ���ο� ���� ���� �� ������Ʈ
                  // ���� �ʱ�ȭ �� �ణ�� ������ �ΰ� ������ �ٽ� ������
            	  setTimeout(function() {
                  map.setCenter(coords);

                  // ��Ŀ ǥ��
                  var marker = new kakao.maps.Marker({
                      map: map,
                      position: coords
                  });

                  // ���������� ǥ��
                  var infowindow = new kakao.maps.InfoWindow({
                      content: '<div style="width:150px;text-align:center;padding:6px 0;">' + location + '</div>'
                  });
                  infowindow.open(map, marker);
                  
                  // ���� ���̾ƿ� ����
                  map.relayout(); // ���̾ƿ� �ٽ� ���

                  // ���� �ε� �Ϸ� �� ��� ǥ��
                  var eventDetails = document.getElementById('eventDetails');
                  eventDetails.style.display = 'block';
              	}, 100); 
              } else {
                  console.error("�ּ� ��ȯ ����: " + status);
              }
          });
      }
      
      // �̺�Ʈ Ŭ�� �� �� ���� ǥ��
      function handleEventClick(info) {
          selectedEvent = info.event;
          mouseX = info.jsEvent.clientX;
          mouseY = info.jsEvent.clientY;

          // �̺�Ʈ �� ������ modal�� ǥ��
          document.getElementById('eventTitle').innerText = selectedEvent.title;

          // ��¥ �� �ð��� �ð��� �������� ����
          const startDate = new Date(selectedEvent.start);
          const endDate = new Date(selectedEvent.end + 60 * 60 * 1000);
          
          const startTime = startDate.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', timeZone: 'Asia/Seoul' });
          const endTime = endDate.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', timeZone: 'Asia/Seoul' });

          document.getElementById('eventTime').innerText = startTime + " ~ " + endTime;
         
          // ��� (���⼭ ��Ҵ� extendedProps�� ����)
		  document.getElementById('eventLocation').innerText = selectedEvent.extendedProps.location || "����";

		  // īī�� ���� �ε�
		  loadMap(selectedEvent.extendedProps.location);
          
          // ����� ȭ�鿡 ǥ��
          var eventDetails = document.getElementById('eventDetails');
          eventDetails.style.left = mouseX + 'px';
          eventDetails.style.top = mouseY + 'px';
          eventDetails.style.display = 'block';
      }
      
/*    // īī�� ���� �ε� �Լ�
      function loadMap(location) {
          var mapContainer = document.getElementById('map');
          mapContainer.innerHTML = ''; // ���� ���� ���� �ʱ�ȭ

          var geocoder = new kakao.maps.services.Geocoder();

          // �ּ�-��ǥ ��ȯ�� ���� īī�� ���� API ȣ��
          geocoder.addressSearch(location, function(result, status) {
              if (status === kakao.maps.services.Status.OK) {
                  var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                  // ���ο� ���� ����
                  var mapOption = {
                      center: coords,
                      level: 3
                  };

                  var map = new kakao.maps.Map(mapContainer, mapOption);

                  // ��Ŀ ǥ��
                  var marker = new kakao.maps.Marker({
                      map: map,
                      position: coords
                  });

                  // ���������� ǥ��
                  var infowindow = new kakao.maps.InfoWindow({
                      content: '<div style="width:150px;text-align:center;padding:6px 0;">' + location + '</div>'
                  });
                  infowindow.open(map, marker);

                  // ������ �߽��� ��������� ���� ��ġ�� �̵���Ŵ
                  map.setCenter(coords);
              }
          });
      }
 */
      // ��� �ݱ�
      function closeEventDetails() {
          var eventDetails = document.getElementById('eventDetails');
          eventDetails.style.display = 'none';
      }

    </script>
  </head>
  <body>
  
      <div id='calendar'></div><br>
  
<!--   <p style="margin-top:-12px">
    <em class="link">
        <a href="javascript:void(0);" onclick="window.open('http://fiy.daum.net/fiy/map/CsGeneral.daum', '_blank', 'width=981, height=650')">
            Ȥ�� �ּ� ����� �߸� ������ ��쿡�� ���⿡ �������ּ���.
        </a>
    </em>
</p>
<div id="map" style="width:100%;height:350px;"></div>

<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=e1ec5378979a9f3ffe97d798bdcd05e1&libraries=services"></script>
<script>
var mapContainer = document.getElementById('map'), // ������ ǥ���� div 
    mapOption = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // ������ �߽���ǥ
        level: 3 // ������ Ȯ�� ����
    };  

// ������ �����մϴ�    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// �ּ�-��ǥ ��ȯ ��ü�� �����մϴ�
var geocoder = new kakao.maps.services.Geocoder();

// �ּҷ� ��ǥ�� �˻��մϴ�
geocoder.addressSearch('����Ư����ġ�� ���ֽ� ÷�ܷ� 242', function(result, status) {

    // ���������� �˻��� �Ϸ������ 
     if (status === kakao.maps.services.Status.OK) {

        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

        // ��������� ���� ��ġ�� ��Ŀ�� ǥ���մϴ�
        var marker = new kakao.maps.Marker({
            map: map,
            position: coords
        });

        // ����������� ��ҿ� ���� ������ ǥ���մϴ�
        var infowindow = new kakao.maps.InfoWindow({
            content: '<div style="width:150px;text-align:center;padding:6px 0;">�츮ȸ��</div>'
        });
        infowindow.open(map, marker);

        // ������ �߽��� ��������� ���� ��ġ�� �̵���ŵ�ϴ�
        map.setCenter(coords);
    } 
});    
</script> -->
  

    
    <!-- Event Details Modal (Initially Hidden) -->
    <div id="eventDetails" style="position: absolute; background: white; padding: 20px; border: 1px solid #ccc; display: none; width:500px; z-index:1000;">
        <h2 id="eventTitle"></h2>
        <div id="eventTimePlace">
            <p>�ð�: <span id="eventTime"></span></p>
            <p>�ּ�: <span id="eventLocation"></span></p>
            <p>�����ּ�: <span id="eventLocation"></span></p>
            <p>
            ��ġ: <div id="map" style="width:100%;height:350px;"></div> <!-- īī�� ���� ǥ�� ���� -->
        	</p>
        </div>
        <button onclick="closeEventDetails()">�ݱ�</button>
    </div>
    
<%--     <h1>�׽�Ʈ�� �ؽ�Ʈ</h1>
                                <table border="1" class="table table-striped table-bordered table-hover">
                                <thead>
                                    <tr>
                                    	<th>�湮��¥</th>
                                        <th>�̸�</th>
                                        <th>��ȣ</th>
                                    </tr>
                                </thead>
                         		<c:forEach items="${list}" var="board">
                     			<tr>
                     				<td><c:out value="${board.visitdate}"/></td>
                     				<td><c:out value="${board.cname}"/></td>
                     				<td><c:out value="${board.rnum}"/></td>
                     			</tr>
                     			</c:forEach>
                     			</table>
<div id="jsonOutput"></div>
0.............<script>
    var jsonData = [
        <c:forEach var="board" items="${list}" varStatus="status">
            {
                "visitdate": "<c:out value="${board.visitdate}"/>",
                "cname": "<c:out value="${board.cname}"/>",
            }
            <c:if test="${!status.last}">,</c:if> <!-- ������ ��� �ڿ� ��ǥ�� ���ֱ� ���� ���� �߰� -->
        </c:forEach>
    ];

    // JSON ������ ��� (�ֿܼ� ���)
    console.log(jsonData);
    
    // �ڹٽ�ũ��Ʈ���� JSON �����ͷ� ó���� �� ����
    jsonData.forEach(function(board) {

        document.write("title: " + board.cname + "<br>");
        document.write("start: " + board.visitdate + "<br><br>");
    });

    var jsonData = [
        <c:forEach var="board" items="${list}" varStatus="status">
            {
                "visitdate": "<c:out value="${board.visitdate}"/>",
                "cname": "<c:out value="${board.cname}"/>"
            }
            <c:if test="${!status.last}">,</c:if> <!-- ������ ��� �ڿ� ��ǥ�� ���ֱ� ���� ���� �߰� -->
        </c:forEach>
    ];

    // JSON �����͸� ���ڿ��� ��ȯ�Ͽ� HTML ��ҿ� ���
    var jsonString = JSON.stringify(jsonData);
    document.getElementById("jsonOutput").textContent = jsonString;
</script> --%>

  </body>
</html>