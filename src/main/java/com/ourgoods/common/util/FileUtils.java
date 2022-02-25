package com.ourgoods.common.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

//import javax.imageio.ImageIO;
//import java.awt.image.BufferedImage;
//import java.awt.Graphics2D;

import org.apache.commons.io.FilenameUtils;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.ourgoods.board.vo.AttachVO;
import com.ourgoods.common.exception.AttachFileException;


@Component
public class FileUtils {
	/* 오늘 날짜 */
	private final String today = LocalDate.now().format(DateTimeFormatter.ofPattern("yyMMdd"));
	/* 업로드 경로 */
	private final String uploadPath = Paths.get("C:", "board", "upload", today).toString();
	
	/* save_name 랜덤 문자열 */
	private final String getRandomString() {
		return UUID.randomUUID().toString().replaceAll("-", "");
	}
	
	public List<AttachVO> uploadFiles(@RequestParam MultipartFile[] files, @RequestParam int pcode) {
		
		List<AttachVO> list = new ArrayList<AttachVO>();
		
		File dir = new File(uploadPath);
		if(dir.exists() == false) {
			dir.mkdirs();
		}
		
		for(MultipartFile file : files) {
			if(file.getSize() < 1) {
				continue;
			}
			try {
				/* 파일 확장자 */
				final String extension = FilenameUtils.getExtension(file.getOriginalFilename());
				/* save_name (랜덤 문자열 + 확장자) */
				final String saveName = getRandomString() + "." + extension;
				/* 업로드 경로에 saveName과 동일한 이름의 파일 생성 */
				File target = new File(uploadPath, saveName);
				file.transferTo(target);
				
				AttachVO attach = new AttachVO();
				System.out.println(pcode);
				attach.setPostCode(pcode);
				System.out.println(file.getOriginalFilename());
				attach.setOriginalName(file.getOriginalFilename());
				System.out.println(saveName);
				attach.setSaveName(saveName);
				System.out.println(file.getSize());
				attach.setSize((int)file.getSize());
				
				attach.setFilePath("null");
				
				list.add(attach);
				//System.out.println(list);
				
				////////////////////////////////////////////////////////////////
				//썸네일
				
				/*
				File thumbnail = new File(uploadPath, "s_"+saveName);
				BufferedImage bo_image = ImageIO.read(target);
				
				//비율
				double ratio = 3;
				int width = (int) (bo_image.getWidth() / ratio);
				int height = (int) (bo_image.getHeight() / ratio);
				
														//(넓이, 높이, 생설될 이미지의 타입)
				BufferedImage bt_image = new BufferedImage(width, height, BufferedImage.TYPE_3BYTE_BGR);
				
				Graphics2D graphic = bt_image.createGraphics();
							   //(그릴 이미지, x좌표, y좌표, 넓이, 높이, imageObserver)
				graphic.drawImage(bo_image, 0, 0, width, height, null);
				
				ImageIO.write(bt_image, "jpg", thumbnail);
				*/
				
				/*
				File thumbnail = new File(uploadPath, "s_"+saveName);
				
				BufferedImage bo_image = ImageIO.read(target);
				
				//비율
				double ratio = 3;
				int width = (int) (bo_image.getWidth() / ratio);
				int height = (int) (bo_image.getHeight() / ratio);
				
				Thumbnails.of(target)
				.size(width, height)
				.toFile(thumbnail);
				*/
				
			} catch (IOException e) {
				throw new AttachFileException("["+file.getOriginalFilename()+"] failed to save file...");
			} catch (Exception e) {
				throw new AttachFileException("["+file.getOriginalFilename()+"] failed to save file...");
			}
		}
		
		return list;
	}
}
