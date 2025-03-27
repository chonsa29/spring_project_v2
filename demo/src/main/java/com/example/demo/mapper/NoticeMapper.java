package com.example.demo.mapper;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.model.Notice;

@Mapper
public interface NoticeMapper {

	List<Notice> qnaNotice(HashMap<String, Object> map);

	int selectNotice(HashMap<String, Object> map);

	Notice noticeSelect(HashMap<String, Object> map);

	void noticeUpdate(HashMap<String, Object> map);

	void noticeDelete(HashMap<String, Object> map);

	void updateNoticeCnt(HashMap<String, Object> map);

	void noticeInsert(HashMap<String, Object> map);

}
