# This provides some really simple path munging to flip conda/pyenv

CONDA_HOME="$HOME/anaconda3"
PYENV_HOME="$HOME/.pyenv"
CONDA_ALTH="$HOME/anaconda"

function detect_conda_pyenv() {
    # Detect anaconda
    local HAS_CONDA=false
    local HAS_PYENV=false
    if [[ -d "$CONDA_HOME" ]]; then
        HAS_CONDA=true
    elif [[ -d "$CONDA_ALTH" ]]; then
        HAS_CONDA=true
        export CONDA_HOME="$CONDA_ALTH"
    fi

    # Detect pyenv
    if [[ -d "$PYENV_HOME" ]]; then
        HAS_PYENV=true
    fi

    if [[ $HAS_CONDA == true ]] && [[ $HAS_PYENV == true ]]; then
        return 0
    fi
    return 1
}

if detect_conda_pyenv; then
    function _drop_conda_and_pyenv_from_path() {
        if ! detect_conda_pyenv; then
            echo "Don't have both conda and pyenv in home"
            return 1
        fi

        local conda_pth="$CONDA_HOME/bin"
        local pyenv_pth="$PYENV_HOME/shims"
        local pyenv_vpth="$PYENV_HOME/plugins/pyenv-virtualenv/shims"
        local rm_pths=("$conda_pth" "$pyenv_pth" "$pyenv_vpth")

        local TEMP_PATH=":$PATH:"
        for rm_pth in "${rm_pths[@]}"; do
            TEMP_PATH=${TEMP_PATH/:$rm_pth:/:}
        done
        TEMP_PATH=${TEMP_PATH%:}
        TEMP_PATH=${TEMP_PATH#:}

        export PATH="$TEMP_PATH"

        return 0
    }

    function use_pyenv() {
        if ! _drop_conda_and_pyenv_from_path; then
            return 2
        fi

        local conda_pth="$CONDA_HOME/bin"
        local pyenv_pth="$PYENV_HOME/shims"
        local pyenv_vpth="$PYENV_HOME/plugins/pyenv-virtualenv/shims"
        if [[ -d "$pyenv_vpth" ]]; then
            pyenv_pth="$pyenv_vpth:$pyenv_pth"
        fi

        export PATH="$pyenv_pth:$conda_pth:$PATH"

        return 0
    }

    function use_conda() {
        if ! _drop_conda_and_pyenv_from_path; then
            return 2
        fi

        local conda_pth="$CONDA_HOME/bin"
        local pyenv_pth="$PYENV_HOME/shims"
        local pyenv_vpth="$PYENV_HOME/plugins/pyenv-virtualenv/shims"
        if [[ -d "$pyenv_vpth" ]]; then
            pyenv_pth="$pyenv_vpth:$pyenv_pth"
        fi

        export PATH="$conda_pth:$pyenv_pth:$PATH"

        return 0
    }
fi
