<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    isELIgnored="false"  %>
 <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<%
  request.setCharacterEncoding("UTF-8");
%>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<table border="1"  align="center"  width="80%">
    <tr align="center"   bgcolor="lightgreen">
      <td ><b>구매자코드</b></td>
      <td><b>판매글코드</b></td>
   </tr>
  
   <c:forEach var="w" items="${wishlist}" >     
   <tr align="center">
      <td>${w.wucode}</td>
      <td>${w.wpcode}</td>
    </tr>
  </c:forEach> 
</table>
</body>
</html>