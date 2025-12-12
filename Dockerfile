FROM python:3.12.8-slim

# Do not use env as this would persist after the build and would impact your containers, children images
ARG DEBIAN_FRONTEND=noninteractive

# force the stdout and stderr streams to be unbuffered.
ENV PYTHONUNBUFFERED=1

# hadolint ignore=DL3008
RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --uid 10000 -ms /bin/bash runner

WORKDIR /home/runner/app

USER 10000

ENV PATH="${PATH}:/home/runner/.local/bin"

COPY --chown=runner:runner ./  ./

# Fixed: Added --no-cache-dir and pinned versions to satisfy Hadolint (DL3013, DL3042)
RUN pip install --no-cache-dir --upgrade pip==24.3.1 \
    && pip install --no-cache-dir poetry==1.8.5 \
    && poetry install --only main

EXPOSE 8000

# ENTRYPOINT [ "poetry", "run" ]

# YOUR CODE HERE
# Fixed: Used JSON notation and sh -c to allow variable expansion (DL3025)
CMD ["sh", "-c", "poetry run uvicorn app.main:app --host 0.0.0.0 --port $PORT"]
