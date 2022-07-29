package com.korea.visit;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import dao.VisitDAO;
import util.MyCommon;
import vo.VisitVO;

@Controller
public class VisitController {
	
	@Autowired
	ServletContext application;
	
	@Autowired
	HttpServletRequest request;
	
	@Autowired
	HttpSession session;
	
	VisitDAO visit_dao;
	
	public void setVisit_dao(VisitDAO visit_dao) {
		this.visit_dao = visit_dao;
	}
	
	//목록 전체 조회
	@RequestMapping(value= {"/","/list.do"})
	public String list(Model model) {
		List<VisitVO> list = visit_dao.selectList();
		
		model.addAttribute("list",list);
		
		return MyCommon.VIEW_PATH+"visit_list.jsp";
	}
	
	//새글 쓰기 폼으로 이동
	@RequestMapping("/insert_form.do")
	public String insert_form() {
		return MyCommon.VIEW_PATH+"visit_insert_form.jsp";
	}
	
	//새 글 작성
	@RequestMapping("/insert.do")
	public String insert(VisitVO vo, HttpServletRequest request) {
		//insert.do?name=홍길동&content=내용&pwd=1111
		String ip = request.getRemoteAddr();
		vo.setIp(ip);
		
		String webPath = "/resources/upload/";
		String savePath = application.getRealPath(webPath);
		System.out.println(savePath);
		
		//업로드된 파일의 정보
		MultipartFile photo = vo.getPhoto();
		
		String filename = "no_file";
		
		//업로드된 파일이 존재한다면
		if(!photo.isEmpty()) {
			//업로드될 실제 파일명
			filename=photo.getOriginalFilename();
			
			File saveFile = new File(savePath, filename);
			if(!saveFile.exists()) {
				saveFile.mkdirs();
			} else {
				//동명파일명 방지
				long time = System.currentTimeMillis();
				filename = String.format("%d_%s", time, filename);
				saveFile = new File(savePath, filename);
			}
			
			try {
				photo.transferTo(saveFile);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
		}
		
		vo.setFilename(filename); //vo에 묶어서 같이 전달하기
		
		int res =  visit_dao.insert(vo);
		
		return "redirect:list.do"; 
		
	}
	
		//게시글 삭제
		@RequestMapping("/delete.do")
		@ResponseBody //return 값을 view 형태로 인식하지 않고 콜백메서드로 전달하기 위한 어노테이션
		public String delete(int idx, String pwd) {
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("idx", idx);
			map.put("pwd", pwd);
			
			int res = visit_dao.delete(map);
			
			String result="no";
			
			if( res == 1) {
				result="yes";
			}
			
			String finRes= String.format("[{'res':'%s'}]",result);
			
			
			return finRes;
		}
		
		//글 수정 페이지로 전환
		@RequestMapping("/modify_form.do")
		public String modify_form(Model model, int idx) {
			VisitVO vo = visit_dao.selectOne(idx);
			
			model.addAttribute("vo",vo);
			
			return MyCommon.VIEW_PATH+"modify_form.jsp";
		}
		
		//진짜 게시글 수정
		@RequestMapping("/modify.do")
		public String modify(VisitVO vo, HttpServletRequest request) {
			String ip = request.getRemoteAddr();
			vo.setIp(ip);
			
			int res = visit_dao.update(vo);
			
			return "redirect:list.do";
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
}
