/* Create Schema */

/* 사용자 */
CREATE TABLE users
(
	user_id VARCHAR(50) NOT NULL,
    user_password VARCHAR(100) NOT NULL,
    user_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(11) NOT NULL,
    birthday DATE NOT NULL,
    gender ENUM('남자', '여자') NOT NULL,
    pregnant_flag BOOLEAN NOT NULL DEFAULT FALSE,
    feeding_flag BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY(user_id)
);

/* 가족 */
CREATE TABLE family
(
	user_id VARCHAR(50) NOT NULL,
	family_id VARCHAR(50) NOT NULL,
    PRIMARY KEY(user_id, family_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

/* 의약품 폐기 정보 */
CREATE TABLE medication_discard_info
(
	medication_discard_id INT AUTO_INCREMENT NOT NULL,
    medication_type VARCHAR(50) NOT NULL,
    discard_method TEXT NOT NULL,
    PRIMARY KEY(medication_discard_id)
);

/* 사용자 복용약 */
CREATE TABLE user_medication
(
	user_medication_id INT AUTO_INCREMENT NOT NULL,
    user_id VARCHAR(50) NOT NULL,
    medication_discard_id INT NOT NULL,
    medication_name VARCHAR(100) NOT NULL,
    start_date DATE NULL,
    end_date DATE NULL,
    expiration_date DATE NULL,
    interval_time TIME NULL,
    alarm_flag BOOLEAN NOT NULL,
    family_notify_flag BOOLEAN NOT NULL,
    PRIMARY KEY(user_medication_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY(medication_discard_id) REFERENCES medication_discard_info(medication_discard_id) ON DELETE RESTRICT
);

/* 사용자 복용약 알람 */
CREATE TABLE user_medication_alarm
(
	user_medication_id INT NOT NULL,
	medication_alarm_time TIME NOT NULL,
    PRIMARY KEY(user_medication_id, medication_alarm_time),
    FOREIGN KEY(user_medication_id) REFERENCES user_medication(user_medication_id) ON DELETE CASCADE
);

/* 사용자 복용약 복용 */
CREATE TABLE user_medication_intake
(
	medication_intake_id INT AUTO_INCREMENT NOT NULL,
    user_medication_id INT NOT NULL,
    intake_date DATE NOT NULL,
    intake_time TIME NOT NULL,
    PRIMARY KEY(medication_intake_id),
    FOREIGN KEY(user_medication_id) REFERENCES user_medication(user_medication_id) ON DELETE CASCADE
);

/* 성분 */
CREATE TABLE ingredient
(
	ingredient_id INT AUTO_INCREMENT NOT NULL,
    ingredient_name VARCHAR(100) NOT NULL,
    ingredient_english_name VARCHAR(100) NOT NULL,
    PRIMARY KEY(ingredient_id)
);

/* 사용자 성분 */
CREATE TABLE user_ingredient
(
	user_id VARCHAR(50) NOT NULL,
    ingredient_id INT NOT NULL,
    PRIMARY KEY(user_id, ingredient_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY(ingredient_id) REFERENCES ingredient(ingredient_id) ON DELETE RESTRICT
);

/* 영양소 */
CREATE TABLE nutrient
(
	nutrient_id INT AUTO_INCREMENT NOT NULL,
	nutrient_name VARCHAR(100) NOT NULL,
    unit VARCHAR(10) NOT NULL,
    PRIMARY KEY(nutrient_id)
);

/* 사용자 영양소 섭취량 */
CREATE TABLE user_nutrient_intake
(
	user_id VARCHAR(50) NOT NULL,
    nutrient_id INT NOT NULL,
    intake INT NOT NULL,
    PRIMARY KEY(user_id, nutrient_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY(nutrient_id) REFERENCES nutrient(nutrient_id) ON DELETE RESTRICT
);

/* 영양소 섭취 기준 */
CREATE TABLE nutrient_intake_standard
(
	nutrient_intake_standard_id INT AUTO_INCREMENT NOT NULL,
    nutrient_id INT NOT NULL,
    sex ENUM('M', 'F', 'X') NOT NULL,
    min_age INT NOT NULL,
    max_age INT NOT NULL,
    state ENUM('0', '1', '2') NOT NULL,
    average_need FLOAT DEFAULT 0.0,
    recommend_intake FLOAT DEFAULT 0.0,
    adequate_intake FLOAT DEFAULT 0.0,
    limit_intake FLOAT DEFAULT 0.0,
    PRIMARY KEY(nutrient_intake_standard_id),
    FOREIGN KEY(nutrient_id) REFERENCES nutrient(nutrient_id) ON DELETE CASCADE
);

/* 보건 의료인 */
CREATE TABLE health_profession
(
	health_profession_id VARCHAR(50) NOT NULL,
    health_profession_password VARCHAR(100) NOT NULL,
    health_profession_name VARCHAR(50) NOT NULL,
    classification ENUM('doctor', 'pharmacist') NOT NULL,
    medical_institution VARCHAR(100) NOT NULL,
    PRIMARY KEY(health_profession_id)
);

/* 카테고리 */
CREATE TABLE category
(
	category_id INT AUTO_INCREMENT NOT NULL,
    category_name VARCHAR(50) NOT NULL,
    PRIMARY KEY(category_id)
);

/* 상담 게시글 */
CREATE TABLE consultation_post
(
	consultation_post_id INT AUTO_INCREMENT NOT NULL,
    user_id VARCHAR(50) NOT NULL,
    category_id INT NOT NULL,
    title VARCHAR(100) NOT NULL,
    content TEXT NOT NULL,
    post_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(consultation_post_id),
    FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY(category_id) REFERENCES category(category_id) ON DELETE RESTRICT
);

/* 상담 답변 */
CREATE TABLE consultation_reply
(
	consultation_reply_id INT AUTO_INCREMENT NOT NULL,
    consultation_post_id INT NOT NULL,
    health_profession_id VARCHAR(50) NOT NULL,
    content TEXT NOT NULL,
    reply_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    update_date DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(consultation_reply_id),
    FOREIGN KEY(consultation_post_id) REFERENCES consultation_post(consultation_post_id) ON DELETE CASCADE,
    FOREIGN KEY(health_profession_id) REFERENCES health_profession(health_profession_id) ON DELETE CASCADE
);

/* 약국 */
CREATE TABLE pharmacy
(
	pharmacy_id INT AUTO_INCREMENT NOT NULL,
    pharmacy_name VARCHAR(100) NOT NULL,
    address VARCHAR(100) NOT NULL,
    PRIMARY KEY(pharmacy_id)
);

/* 약국 오픈 요일 */
CREATE TABLE pharmacy_open_day
(
	open_day TINYINT NOT NULL,
    pharmacy_id INT NOT NULL,
    PRIMARY KEY(open_day, pharmacy_id),
    FOREIGN KEY(pharmacy_id) REFERENCES pharmacy(pharmacy_id) ON DELETE CASCADE
);