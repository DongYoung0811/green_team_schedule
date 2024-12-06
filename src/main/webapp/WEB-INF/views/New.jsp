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
    <script>

      document.addEventListener('DOMContentLoaded', function() {
        var calendarEl = document.getElementById('calendar');
        var jsonData = [
            <c:forEach var="board" items="${list}" varStatus="status">
                {
                    "title": "<c:out value="${board.cname}"/>",
                    "start": "<c:out value="${board.visitdate}"/>",
                    "end": "<c:out value="${board.visitdate}"/>",
                }
                <c:if test="${!status.last}">,</c:if> <!-- ������ ��� �ڿ� ��ǥ�� ���ֱ� ���� ���� �߰� -->
            </c:forEach>
        ];
        var calendar = new FullCalendar.Calendar(calendarEl, {
            initialView: 'dayGridMonth',
        	locale: 'ko',
            events: jsonData // jsonData �迭�� events�� ����
            ,
            eventClick: function(info) {
                alert('Event: ' + info.event.title);
                alert('Coordinates: ' + info.jsEvent.pageX + ',' + info.jsEvent.pageY);
                alert('View: ' + info.view.type);

                // change the border color just for fun
                info.el.style.borderColor = 'red';
              }
        });

        calendar.render();
    });
      

    </script>
  </head>
  <body>
    <div id='calendar'></div>
    <h1>�׽�Ʈ�� �ؽ�Ʈ</h1>
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
<script>
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
</script>

  </body>
</html>