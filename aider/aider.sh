#!/bin/bash

GEMINI_TOKEN=$HOME/.config/gemini.token
MISTRAL_TOKEN=$HOME/.config/mistral.token
HUGGINGFACE_TOKEN=$HOME/.config/huggingface.token
OPENROUTER_TOKEN=$HOME/.config/openrouter.token
[ -e $GEMINI_TOKEN ] && export GEMINI_API_KEY=$(cat $GEMINI_TOKEN)
[ -e $MISTRAL_TOKEN ] && export MISTRAL_API_KEY=$(cat $MISTRAL_TOKEN)
[ -e $HUGGINGFACE_TOKEN ] && export HUGGINGFACE_API_KEY=$(cat $HUGGINGFACE_TOKEN)
[ -e $OPENROUTER_TOKEN ] && export OPENROUTER_API_KEY=$(cat $OPENROUTER_TOKEN)

OPTS="--no-auto-commits --dark-mode --watch-files $@"

models=(
    "gemini/gemini-2.5-flash-preview-05-20"
    "mistral/mistral-large-latest"
    "mistral/magistral-medium-2506"
    "mistral/devstral-small-2505"
    "openrouter/qwen/qwen3-235b-a22b:free"
    "openrouter/deepseek/deepseek-r1:free"
)
context_size=(
    "1000000"
    "128000"
    "128000"
    "128000"
    "40960"
    "163840"
)
if [ -z "$MODEL" ]; then
    echo "Available Models:"
    for i in "${!models[@]}"; do
        echo "$((i+1)). ${models[$i]}"
    done
    read -p "Enter model number (default: 1): " choice
    if [[ -z "$choice" ]]; then
        model_index=0
    elif [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#models[@]} )); then
        model_index=$((choice-1))
    else
        echo "Invalid choice. Exiting ..."
        exit 1
    fi
    MODEL="${models[$model_index]}"
    CTX_SIZE=$(( ${context_size[$model_index]} * 98 / 100 ))
else
    echo "Using model from MODEL environment variable: $MODEL"
    CTX_SIZE=0
fi

if [ -d .git ]; then
    USE_GIT=Y
    REPO_SIZE=$(du --block-size=1 -c $(git ls-files) | tail -1 | cut -f1)
    # 1 token ≈ 4 characters, 1 character ≈ 1 byte
    if [ $REPO_SIZE -lt $((CTX_SIZE*4)) ]; then
        FILES=$(git ls-files)
        OPTS+=" --map-tokens 0"
    else
        FILES=
    fi
fi
if ls CONVENTIONS.md 2> /dev/null; then
    RFILES="--read CONVENTIONS.md"
fi
[ -z "$USE_GIT" ] && OPTS+=" --no-git"

aider --model "$MODEL" $OPTS $FILES $RFILES
