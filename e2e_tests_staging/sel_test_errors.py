from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC

import time

import sel_utils

#=#=#=#
# Utility function
#  Test for errors when loading list content - Should display snackbar
#=#
def displays_snackbar_on_list_retrieval_error(index_file_name):
    # ------------------------------------------------------------------------------------------
    # | Setup app driver
    # ------------------------------------------------------------------------------------------
    driver = sel_utils.setup_driver()

    # ------------------------------------------------------------------------------------------
    # | Open app
    # ------------------------------------------------------------------------------------------
    sel_utils.open_app(driver, index_file_name)


    # ------------------------------------------------------------------------------------------
    # | Test initial state - Existence of expected elements
    # ------------------------------------------------------------------------------------------
    # Check if the request button exists
    request_button_id = 'dog-breed-list-request-button'
    request_button = driver.find_element(By.ID, request_button_id)
    assert request_button is not None

    # Verify the snackbar is not present before it should appear
    snackbar = driver.find_element(By.ID, "snackbar")
    assert snackbar is not None


    # ------------------------------------------------------------------------------------------
    # | Request dog list - Test non-existence of elements that should appear/change
    # ------------------------------------------------------------------------------------------
    assert not snackbar.is_displayed()
    
    # ------------------------------------------------------------------------------------------
    # | Request dog list - Prompt state change AND wait
    # ------------------------------------------------------------------------------------------

    # Click the request button
    request_button.click()

    # Wait long enough for the request to be processed
    time.sleep(3.5)

    # ------------------------------------------------------------------------------------------
    # | Request dog list display - Expect snackbar
    # ------------------------------------------------------------------------------------------
    
    snackbar = driver.find_element(By.ID, "snackbar")
    assert snackbar.is_displayed()


    # ------------------------------------------------------------------------------------------
    # | End the tests - cleanup
    # ------------------------------------------------------------------------------------------

    # Close the browser
    driver.quit()

#=#=#=#
# Test for server error handling when loading list content
#=#
def test_server_error_on_list_retrieval():
    displays_snackbar_on_list_retrieval_error("server_error_for_list_index.html")

#=#=#=#
# Test for invalid signature handling when loading list content
#=#
def test_invalid_sig_error_on_list_retrieval():
    displays_snackbar_on_list_retrieval_error("invalid_sig_for_list_index.html")

#=#=#=#
# Test for invalid signature handling when loading initial content
#=#
def test_invalid_sig_error_on_init():
    # ------------------------------------------------------------------------------------------
    # | Setup app driver
    # ------------------------------------------------------------------------------------------
    driver = sel_utils.setup_driver()

    # ------------------------------------------------------------------------------------------
    # | Open app
    # ------------------------------------------------------------------------------------------
    sel_utils.open_app(driver, "invalid_sig_for_init_index.html")


    # ------------------------------------------------------------------------------------------
    # | Test initial state - Existence of expected elements
    # ------------------------------------------------------------------------------------------
    # Check if content div element exists
    content_div_id = 'content'
    content_div = driver.find_element(By.ID, content_div_id)
    assert content_div is not None

    # ------------------------------------------------------------------------------------------
    # | Check if content div contains invalid signature text
    # ------------------------------------------------------------------------------------------
    assert content_div.get_attribute('innerHTML') == "Error loading content. Invalid content signature."


    # ------------------------------------------------------------------------------------------
    # | End the tests - cleanup
    # ------------------------------------------------------------------------------------------

    # Close the browser
    driver.quit()


if __name__ == "__main__":
    test_server_error_on_list_retrieval()
    test_invalid_sig_error_on_list_retrieval()
    test_invalid_sig_error_on_init()


