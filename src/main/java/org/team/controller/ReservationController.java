package org.team.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.team.dto.ReservationDTO;
import org.team.mapper.ReservationMapper;

import com.google.gson.Gson;

@Controller
// @RequestMapping("/board/*")
public class ReservationController {

	@Autowired
	private ReservationMapper mapper;
	
	@GetMapping("/New")
	public void list(Model model) {
		
		model.addAttribute("list", mapper.getList());
		System.out.println("list");
		
		/*
		 * Gson gson = new Gson();
		 * 
		 * 
		 * String json = gson.toJson("list");
		 * 
		 * System.out.println(json);
		 */
	}
	
	@GetMapping({"/read"})
	public void get(@RequestParam("bno") Long bno, Model model) {
		
		System.out.println("/read");
		model.addAttribute("board", mapper.reservationRead(bno));
	}
	
	//예약 등록 처리(사용자 예약정보를 ReservationDTO객체로 받음-> DB저장->redirect) 
	 @PostMapping("/reservation/register")
	 public String register(ReservationDTO reservation, RedirectAttributes rttr ) {
		 System.out.println("register: " + reservation);
		 mapper.insert(reservation); // Mapper 직접 호출
		 rttr.addFlashAttribute("result", reservation.getRnum());
	 return "redirect:/reservation/list"; // 등록 후 목록 페이지로 이동
			 
	 }

}
