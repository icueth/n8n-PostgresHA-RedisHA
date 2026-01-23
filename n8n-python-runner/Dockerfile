FROM n8nio/n8n:latest

# สลับเป็น root เพื่อติดตั้ง library เพิ่มเติมถ้าจำเป็น
USER root

# ติดตั้ง python3 และเครื่องมือที่จำเป็น (ปกติมีมาให้อยู่แล้วใน image node แต่กันเหนียว)
# เผื่อ User อยากติดตั้ง pandas หรืออื่นๆ
# RUN apk add --no-cache python3 py3-pip

USER node

# ตัว Task Runner จะใช้คำสั่ง n8n task-runner ในการทำงาน
# ซึ่ง n8n จะจัดการให้เองผ่าน entrypoint หรือ CMD
