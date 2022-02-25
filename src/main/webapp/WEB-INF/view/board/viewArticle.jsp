<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    isELIgnored="false" %>
    
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<%-- 
<c:set var="article"  value="${articleMap.article}"  />
<c:set var="imageFileList"  value="${articleMap.imageFileList}"  />

 --%>
<%
  request.setCharacterEncoding("UTF-8");
%> 

<head>

   <meta charset="UTF-8">
   <title>글보기</title>
   <style>
     #tr_file_upload{
       display:none;
     }
     #tr_btn_modify{
       display:none;
     }

   </style>
   <script  src="http://code.jquery.com/jquery-latest.min.js"></script> 
   <script type="text/javascript" >
     function backToList(obj){
	    obj.action="${contextPath}/board/list";
	    obj.submit();
     }
     

  	function chatSubmit() {
  		document.getElementById('chatSubmit_form').submit();
  	} 
 
	 function fn_enable(obj){
		 document.getElementById("i_title").disabled=false;
		 document.getElementById("i_content").disabled=false;
		 document.getElementById("i_price").disabled=false;
		 document.getElementById("i_imageFileName").disabled=false;
		 document.getElementById("tr_btn_modify").style.display="block";
		 if(document.getElementById("tr_file_upload") != null)
			 document.getElementById("tr_file_upload").style.display="block";
		 document.getElementById("tr_btn_hidden").style.display="none";
	 }
	  
	 function fn_modify_article(obj){
		 obj.action="${contextPath}/board/modify";
		 obj.submit();
	 }
	 
	 function fn_remove_article(url,pcode){
		 var form = document.createElement("form");
		 form.setAttribute("method", "post");
		 form.setAttribute("action", url);
	     var articleNOInput = document.createElement("input");
	     articleNOInput.setAttribute("type","hidden");
	     articleNOInput.setAttribute("name","pcode");
	     articleNOInput.setAttribute("value", pcode);
		 
	     form.appendChild(articleNOInput);
	     document.body.appendChild(form);
	     form.submit();
	 
	 }
	 
	 function readURL(input) {
	     if (input.files && input.files[0]) {
	         var reader = new FileReader();
	         reader.onload = function (e) {
	             $('#preview').attr('src', e.target.result);
	         }
	         reader.readAsDataURL(input.files[0]);
	     }
	 }  
 </script>
</head>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<body>
<form:form id="chatSubmit_form" action="/chatMessage" method="GET" modelAttribute="chatRoom">
			<form:input type="hidden" path="post_code" value="${board.pcode}"/>
			<form:input type="hidden" path="post_title" value="${board.ptitle}"/>
			<a href="javascript:{}" onclick="chatSubmit()">
			

				<form:input type="hidden" path="seller_name" value="gildong"/>
				
				<form:input type="hidden" path="seller_code" value="1"/>
				
				<button id="btn_chat">
					채팅으로 거래하기
				</button>
			</a>
		</form:form>
  <form name="frmArticle" method="post"  action="${contextPath}"  enctype="multipart/form-data">
  
  <table  border=0  align="center">
  <tr>
   <td width=150 align="center" bgcolor=#FF9933>
      글번호
   </td>
   <td >
    <input type="text"  value="${board.pcode }"  disabled />
    <input type="hidden" name="pcode" value="${board.pcode}"  />
   </td>
  </tr>
  <tr>
    <td width="150" align="center" bgcolor="#FF9933">
      작성자 아이디
   </td>
   <td >
    <input type=text value="${board.scode }" name="scode"  disabled />
   </td>
  </tr>
  <tr>
    <td width="150" align="center" bgcolor="#FF9933">
      제목 
   </td>
   <td>
    <input type=text value="${board.ptitle }"  name="ptitle"  id="i_title" disabled />
   </td>   
  </tr>
  <tr>
    <td width="150" align="center" bgcolor="#FF9933">
      가격
   </td>
   <td>
    <input type=text value="${board.price }"  name="price"  id="i_price" disabled />
   </td>   
  </tr>
  <tr>
    <td width="150" align="center" bgcolor="#FF9933">
      내용
   </td>
   <td>
    <textarea rows="20" cols="60"  name="pcontent"  id="i_content"  disabled />${board.pcontent }</textarea>
   </td>  
  </tr>

 <c:if test="${not empty fileList && fileList!='null' }">
	  <c:forEach var="item" items="${fileList}" varStatus="status" >
		    <tr>
			    <td width="150" align="center" bgcolor="#FF9933"  rowspan="2">
			      이미지${status.count }
			   </td>
			   <td>
			     <input  type= "hidden"   name="originalFileName" value="${item.originalName }" />
			    <%-- <img src="${contextPath}/download.do?articleNO=${article.articleNO}&imageFileName=${item.originalFileName}" id="preview"  /><br> --%>
			   </td>   
			  </tr>  
			  <tr>
			    <td>
			       <input  type="file"  name="imageFileName " id="i_imageFileName"   disabled   onchange="readURL(this);"   />
			    </td>
			 </tr>
		</c:forEach>
 </c:if>  
 	 
  <c:choose> 
	  <c:when test="${not empty article.originalName && article.originalName!='null' }">
	   	<tr>
		    <td width="150" align="center" bgcolor="#FF9933"  rowspan="2">
		      이미지
		   </td>
		   <td>
		     <input  type= "hidden"   name="originalFileName" value="${article.originalName }" />
		    <img src="${contextPath}/download.do?articleNO=${article.articleNO}&imageFileName=${article.originalName}" id="preview"  /><br>
		   </td>   
		  </tr>  
		  <tr>
		    <td ></td>
		    <td>
		       <input  type="file"  name="imageFileName " id="i_imageFileName"   disabled   onchange="readURL(this);"   />
		    </td>
		  </tr> 
		 </c:when>
		 <c:otherwise>
		    <tr  id="tr_file_upload" >
				    <td width="150" align="center" bgcolor="#FF9933"  rowspan="2">
				      이미지
				    </td>
				    <td>
				      <input  type= "hidden"   name="originalFileName" value="${article.imageFileName }" />
				    </td>
			    </tr>
			    <tr>
				    <td ></td>
				    <td>
				       <img id="preview"  /><br>
				       <input  type="file"  name="originalFileName " id="i_imageFileName"   disabled   onchange="readURL(this);"   />
				    </td>
			  </tr>
		 </c:otherwise>
	 </c:choose>
  <tr>
	   <td width="150" align="center" bgcolor="#FF9933">
	      등록일자
	   </td>
	   <td>
	    <input type=text value="<fmt:formatDate value="${article.insertTime}" />" disabled />
	   </td>   
  </tr>
  <tr   id="tr_btn_modify"  align="center"  >
	   <td colspan="2"   >
	       <input type=button value="수정반영하기"   onClick="fn_modify_article(frmArticle)"  >
           <input type=button value="취소"  onClick="backToList(frmArticle)">
	   </td>   
  </tr>
    
  <tr  id="tr_btn_hidden"    >
   <td colspan="2" align="center">
       <c:if test="${member.code == board.scode }">
	      <input type=button value="수정하기" onClick="fn_enable(this.form)">
	      <input type=button value="삭제하기" onClick="fn_remove_article('${contextPath}/board/delete', ${board.pcode})">
	    </c:if>
	    <input type=button value="리스트로 돌아가기"  onClick="backToList(this.form)">
   </td>
  </tr>
 </table>
 </form>
</body>
</html>