package com.example.demo.model;

import java.util.Date;

import lombok.Data;

@Data
public class Member {

	private String userId;
    private Integer groupId;
    private String password;
    private String userName;
    private String address;
    private String email;
    private String birth;
    private String gender;
    private String phone;
    private String status;
    private String nickname;
    private Integer grade;
    private String allergy;
    private Integer point;
    private Date regDate;
    private Integer remainPoint;
    
    // 추가 필드 (DB에는 없지만 화면에 표시하기 위해 사용)
    private String gradeName;
    private String groupName;
    
    // Getters and Setters
    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public Integer getGroupId() { return groupId; }
    public void setGroupId(Integer groupId) { this.groupId = groupId; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getBirth() { return birth; }
    public void setBirth(String birth) { this.birth = birth; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }
    public Integer getGrade() { return grade; }
    public void setGrade(Integer grade) { this.grade = grade; }
    public String getAllergy() { return allergy; }
    public void setAllergy(String allergy) { this.allergy = allergy; }
    public Integer getPoint() { return point; }
    public void setPoint(Integer point) { this.point = point; }
    public Date getRegDate() { return regDate; }
    public void setRegDate(Date regDate) { this.regDate = regDate; }
    public String getGradeName() { return gradeName; }
    public void setGradeName(String gradeName) { this.gradeName = gradeName; }
    public String getGroupName() { return groupName; }
    public void setGroupName(String groupName) { this.groupName = groupName; }
    public void setRemainPoint(Integer remainPoint) {
        this.remainPoint = remainPoint;
    }
}
