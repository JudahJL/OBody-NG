set(WORKFLOW_FILE "${CMAKE_SOURCE_DIR}/.github/workflows/CMake SKSE Setup.yml")

set(WORKFLOW_FILE_DATA
        "name: CMake SKSE Setup\n"
        "\n"
        "on:\n"
        "  push:\n"
        "    branches: [ \"main\" ]\n"
        "  pull_request:\n"
        "    branches: [ \"main\" ]\n"
        "\n"
        "env:\n"
        "  PROJECT_NAME: ${PROJECT_NAME}\n"
        "  PROJECT_VERSION: ${PROJECT_VERSION}\n"
        "\n"
        "\n"
        "jobs:\n"
        "  build:\n"
        "    runs-on: windows-latest\n"
        "    permissions:\n"
        "      contents: write\n"
        "\n"
        "    steps:\n"
        "    - uses: actions/checkout@v4\n"
        "\n"
        "    - name: Setup cmake\n"
        "      uses: lukka/get-cmake@latest\n"
        "\n"
        "    - name: Restore from cache and setup vcpkg executable and data files.\n"
        "      uses: lukka/run-vcpkg@v11\n"
        "      with:\n"
        "        vcpkgJsonGlob: '$\{\{ github.workspace \}\}/vcpkg.json'\n"
        "\n"
        "    - name: Configure and Run CMake Preset for \"Debug\" preset\n"
        "      uses: lukka/run-cmake@v10\n"
        "      with:\n"
        "        configurePreset: 'debug-msvc'\n"
        "        buildPreset: 'build-debug-msvc'\n"
        "\n"
        "    - name: Configure and Run CMake Preset for \"Release\" preset\n"
        "      uses: lukka/run-cmake@v10\n"
        "      with:\n"
        "        configurePreset: 'release-msvc'\n"
        "        buildPreset: 'build-release-msvc'\n"
        "\n"
        "    - name: Deploy Aritfact\n"
        "      uses: actions/upload-artifact@v4.3.3\n"
        "      with:\n"
        "        name: \$\{\{ env.PROJECT_NAME \}\}_\$\{\{ env.PROJECT_VERSION \}\}\n"
        "        path: \$\{\{ github.workspace \}\}/contrib/Distribution/\n"
        "\n"
        "    - name: Upload files to a GitHub release\n"
        "      if: github.event_name == \'push\'\n"
        "      uses: ncipollo/release-action@v1.14.0\n"
        "      with:\n"
        "        token: $\{\{ secrets.GITHUB_TOKEN \}\}\n"
        "        artifacts: $\{\{ github.workspace \}\}/contrib/Artifact/$\{\{ env.PROJECT_NAME \}\}_$\{\{ env.PROJECT_VERSION \}\}.7z\n"
        "        tag: $\{\{ env.PROJECT_VERSION \}\}\n"
        "        commit: main\n"
        "        generateReleaseNotes: true\n"
        "        artifactErrorsFailBuild: true\n"
        "        makeLatest: \"latest\"\n"
        "        name: $\{\{ env.PROJECT_NAME \}\} $\{\{ env.PROJECT_VERSION \}\}\n"
)

# Check if the GitHub environment variable is defined
if (DEFINED ENV{GITHUB_ENV})
    message(STATUS "GitHub environment detected. Skipping workflow modification.")
else ()
    message(STATUS "GitHub environment not detected. Executing workflow modification.")
    file(WRITE ${WORKFLOW_FILE} ${WORKFLOW_FILE_DATA})
endif ()
