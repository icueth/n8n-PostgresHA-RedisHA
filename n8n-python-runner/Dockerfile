FROM n8nio/n8n:latest

USER root
# เพิ่มการลง python เพื่อให้ชัวร์ว่าคำสั่ง python3 ทำงานได้ (ใน image node บางรุ่นอาจจะไม่มี)
RUN apk add --no-cache python3 py3-pip || apt-get update && apt-get install -y python3 python3-pip || true

USER node
