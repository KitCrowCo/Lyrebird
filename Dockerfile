# Lyrebird - local STT (faster-whisper) + TTS (Piper). CPU only; fine on 8-core Ryzen (small/int8 STT runs faster than real time).
FROM python:3.11-slim
# libgomp1: OpenMP runtime used by CTranslate2 (faster-whisper) and onnxruntime (Piper)
RUN apt-get update && apt-get install -y --no-install-recommends libgomp1 espeak-ng cmake build-essential mecab libmecab-dev mecab-ipadic-utf8 && rm -rf /var/lib/apt/lists/*
ENV MECAB_PATH=/usr/lib/mecab/dic/ipadic
RUN mkdir -p /usr/local/etc && \
    cp /etc/mecabrc /usr/local/etc/mecabrc 2>/dev/null || \
    echo "DICDIR /usr/lib/mecab/dic/ipadic" > /usr/local/etc/mecabrc
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
ENV SPEECH_MODELS_DIR=/models SERVER_PORT=8795 PYTHONUNBUFFERED=1
EXPOSE 8795
CMD ["python3", "main.py"]
