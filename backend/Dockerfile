FROM node:20-bookworm-slim
RUN apt-get update \
  && apt-get install -y --no-install-recommends python3 python3-venv \
  && rm -rf /var/lib/apt/lists/* \
  && python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /app

COPY backend/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

COPY backend/gateway/package*.json /app/gateway/
RUN cd /app/gateway && npm ci --omit=dev

COPY backend/gateway /app/gateway
COPY backend/python /app/python
COPY backend/start.sh /app/start.sh
RUN sed -i 's/\r$//' /app/start.sh \
  && chmod +x /app/start.sh

USER node
EXPOSE 444
CMD ["/app/start.sh"]
