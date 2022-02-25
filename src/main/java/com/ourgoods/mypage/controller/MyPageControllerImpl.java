package com.ourgoods.mypage.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.ourgoods.mypage.service.MyPageService;
import com.ourgoods.mypage.vo.ChatRoomVO;
import com.ourgoods.mypage.vo.OrderVO;
import com.ourgoods.mypage.vo.PostVO;
import com.ourgoods.mypage.vo.WishListVO;
import com.ourgoods.user.service.UserService;
import com.ourgoods.user.vo.UserVO;

@RestController
@SessionAttributes("sessionId")
public class MyPageControllerImpl implements MyPageController {

	@Autowired
	private MyPageService mypageService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private UserVO userVO;
	
	@Autowired
	private OrderVO orderVO;
	
	@Autowired
	private PostVO postVO;
	
	@Autowired
	private WishListVO wishlistVO;
	
	@Autowired
	private ChatRoomVO chatroomVO;

	@Override
	@RequestMapping(value="/accounts/my_page/wish_list", method = RequestMethod.POST)
	public List wishlist(@RequestBody Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		HttpSession session = request.getSession();
		UserVO userVO = (UserVO)session.getAttribute("user");
		
		if(paramMap.get("id")==userVO.getId()) {
			wishlistVO.setWucode(userVO.getCode());
			List wishlist = mypageService.wishlist(wishlistVO);

			return wishlist;
		}else {
			
			return null;
		}

		
	}

	@Override
	@RequestMapping(value="/accounts/my_page/order_list", method = RequestMethod.POST)
	public Map<String,Object> orderlist(@RequestBody Map<String,Object> paramMap, HttpServletRequest request,HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
	
		HttpSession session = request.getSession();
		UserVO userVO = (UserVO)session.getAttribute("user");
		
		if(paramMap.get("id")==userVO.getId()) {
			orderVO.setBcode(userVO.getCode());
			postVO.setScode(userVO.getCode());
			List buylist = mypageService.buylist(orderVO);
			List selllist = mypageService.selllist(postVO);
			Map<String, Object> resultMap = new HashMap<String, Object>();
			resultMap.put("buylist", buylist);
			resultMap.put("selllist",selllist);
			
			return resultMap;
		}else {
			
			return null;
		}

	}

//	@Override
//	@RequestMapping(value="/accounts/my_page/chat_list", method = RequestMethod.GET)
//	public List chatlist(@RequestBody Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response) throws Exception {
//		request.setCharacterEncoding("utf-8");
//		response.setContentType("text/html;charset=utf-8");
//		
//		HttpSession session = request.getSession();
//		UserVO userVO = (UserVO)session.getAttribute("user");
//		
//		if(paramMap.get("id")==userVO.getId()) {
//			chatroomVO.setBucode(userVO.getCode());
//			List chatlist = mypageService.chatlist(chatroomVO);
//			
//			return chatlist;
//		}else {
//			
//			return null;
//		}
//	}
	
	@Override
	@RequestMapping(value="/user/search.do", method = RequestMethod.POST)
	public List search(@RequestBody Map<String,Object> paramMap, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		
		List searchlist = mypageService.searchlist((String)paramMap.get("keyword"));
		
		return searchlist;
	}
	
	
	

}

