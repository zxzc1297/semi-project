<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Web socket STOMP SockJS Example</title>
	<!-- jQuery -->
	<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
		<!-- <link rel="stylesheet" href="/resources/css/chatBroadcastChatRoom.css"> -->
	

</head>
<body>
	<div class="container">
		<div class="title_text">
			<h2>${pr_title}</h2>
		</div>
		<div class="row">
			<div class="col_6">
				<div class="row_3">
					<div class="input_group">
						
					<!-- 
						<div class="btn_group">
							<button type="button" id="connect" class="btn btn-sm btn-outline-secondary" onclick="connect()">connect</button>
							<button type="button" id="disconnect" class="btn btn-sm btn-outline-secondary" onclick="disconnect()" disabled>disconnect</button>
						</div>
					 -->
						 
					</div>				
				</div>				
				<div class="col_6">
					<div id="content">
						<div id="content">
							<c:forEach var="chatRoom" items="${chatHistory}">
								<p>
									<span id="chatRoomSenderName">${chatRoom.senderName}</span><br>
									<span id="chatRoomContent">${chatRoom.content}</span><br>
									<span id="chatRoomSendTime">${chatRoom.sendTime}</span><br>
								</p>	
							</c:forEach>
						</div>
					</div>
					<!-- 
					<div>
						<span class="float-right">
							<button id="clear" class="btn btn-primary" onclick="clearBroadcast()" style="display: none;">Clear</button>				
						</span>
					</div>
					-->
				</div>
				<div class="row_3">
					<div class="input_group" id="sendMessage">
						<input type="text" placeholder="Message" id="message" class="form_control"/>
						<div class="input_group_append">
							<button id="send" class="btn btn-primary" onclick="send()">보내기</button>
							<input type="hidden" value="${user.getName()}" id="senderName"/>
							<input type="hidden" value="${user.getCode()}" id="senderId"/>
							<input type="hidden" value="${chatRoom_code}" id="chatRoom_code"/>					
							<input type="hidden" value="${post_code}" id="post_code"/>					
							<input type="hidden" value="${buyuser_code}" id="buyuser_code"/>					
							<input type="hidden" value="${seller_code}" id="seller_code"/>					
						</div>					
					</div>				
				</div>
			</div>
		</div>
	</div>
	
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js" type="text/javascript"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.1.5/sockjs.min.js" type="text/javascript"></script>
	
	<script type="text/javascript">
	
		var stompClient = null;
		var senderName = $('#senderName').val();
		var senderId = $('#senderId').val();
		var seller_code = $('#seller_code').val();
		var buyuser_code = $('#buyuser_code').val();
		var post_code = $('#post_code').val();
		var chatRoom_code = $('#chatRoom_code').val();
		
/*
		function setConnected(connected) {		
			$('#connect').prop('disabled', connected);
			$('#disconnect').prop('disabled', !connected);
			if (connected) {
				$('#sendMessage').show();
			} else {
				$('#sendMessage').hide();				
			}
		};
*/
		
		$(document).ready(connect());
		
		function connect() {
			var socket = new SockJS('${contextPath}/broadcast');
			var url = '/user/' + chatRoom_code + '/queue/messages';
			stompClient = Stomp.over(socket);
			ajaxChatRead(chatRoom_code, senderId);
			
			stompClient.connect({}, function() {
				stompClient.subscribe(url, function(output) {
					console.log("broadcastMessage working");
					showBroadcastMessage(createTextNode(JSON.parse(output.body)));
				});
						//setConnected(true);				
				}, 
						function (err) {
							alert('error' + err);
			});
		};
		
/*
		function disconnect() {
			
			if(stompClient!= null) {
				
				stompClient.disconnect(function() {
					console.log('disconnected...');
					setConnected(false);
				});
			}
		}
*/
		
		
		
		function sendBroadcast(json) {
			
			stompClient.send("/app/broadcast", {}, JSON.stringify(json));
		}
		
		function send() {
			//ajaxChatRoom();
			var content = $('#message').val();
			sendBroadcast({
				'chatRoom_code': chatRoom_code,
				'senderName': senderName,
				'content': content,
				'post_code': post_code,
				'buyuser_code': buyuser_code,
				'senderId': senderId,
				'seller_code': seller_code
				});
			$('#message').val("");
		}
		
		var inputMessage = document.getElementById('message'); 
		inputMessage.addEventListener('keydown', function enterSend(event) {
			
			if (event.keyCode === null) {
				event.preventDefault();
			}
			
			if (event.keyCode === 13) {
				send();
			}
		});
		
		function createTextNode(messageObj) {
			console.log("createTextNode");
			console.log("messageObj: " + messageObj.content);
            return '<p><div class="row alert alert-info"><div class="col_8">' +
            messageObj.senderName +
            '</div><div class="col_4 text-right">' +
            messageObj.content+
            '</div><div>[' +
            messageObj.sendTime +
            ']</div></p>';
        }
		
		function showBroadcastMessage(message) {
            $("#content").html($("#content").html() + message);
        }
		
		function clearBroadcast() {
			$('#content').html("");
		}
		
		
		<%-- 읽음처리 --%>
		function ajaxChatRead(chatRoom_code, reader) {
			console.log("ajaxChatread");
			var flag = "";
			if (reader == buyuser_code) {
				flag = "buy";
			} else {
				flag = "sell";
			}
			$.ajax({
				url:'${contextPath}/chatread/chatroom/ajax',
				type: 'POST',
				data: JSON.stringify({
					chatRoom_code: chatRoom_code,
					flag: flag
				}),
				dataType: 'json',
				contentType: 'application/json'
			})
		}
	
	</script>
</body>
</html>

