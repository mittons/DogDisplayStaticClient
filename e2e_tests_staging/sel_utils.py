from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import os
import time

def setup_driver():
    # Create an instance of ChromeOptions
    options = Options()
    # options.add_argument('--headless')

    # Connect to the existing ChromeDriver running on port 4444
    driver = webdriver.Remote(
        command_executor='http://localhost:4444',
        options=options)

    return driver

def open_app(driver, index_file_name):
    # Use environment variable or default to 7654
    port = os.getenv('STATIC_WEB_TEST_SERVER_PORT', '7654')

    # Check if port is a valid number
    try:
        port_num = int(port)
        if port_num <= 0 or port_num > 65535:
            raise ValueError
    except ValueError:
        print(f"Error: Invalid port number {port} for selenium test: {index_file_name}")
        exit(1)

    # Prompt the app to open
    local_url= f"http://localhost:{port_num}/{index_file_name}"

    driver.get(local_url)

    # Wait for app to open
    time.sleep(5)
