from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import re

import time

import sel_utils

#=#=#=#
# Test for a successful flow of operations and correct state changes through:
#   - Initial state, requesting list, loading spinner while waiting, the list being displayed
#=#
def test_successful_ops_flow():
    # ------------------------------------------------------------------------------------------
    # | Setup app driver
    # ------------------------------------------------------------------------------------------
    driver = sel_utils.setup_driver()

    # ------------------------------------------------------------------------------------------
    # | Open app
    # ------------------------------------------------------------------------------------------
    sel_utils.open_app(driver, "success_index.html")


    # ------------------------------------------------------------------------------------------
    # | Test initial state - Existence of expected elements
    # ------------------------------------------------------------------------------------------
    # Check if the title text is as expected
    title_element = WebDriverWait(driver, 5).until(
        EC.visibility_of_element_located((By.CLASS_NAME, "header-bar"))
    )

    # Retrieve the title text, ensuring it's not None
    title_text = title_element.text if title_element else ""

    # Define the regex pattern to check that the title begins with "Dog Diversity" and ends with "! 🐶"
    pattern = r"^Dog Diversity .*! 🐶$"
    
    # Use re.match to check if the title conforms to the specified pattern
    assert re.match(pattern, title_text), f"Title '{title_text}' does not start with 'Dog Diversity' and end with '! 🐶'."

    # Check if the request button exists
    request_button_id = 'dog-breed-list-request-button'
    request_button = driver.find_element(By.ID, request_button_id)
    assert request_button is not None


    # ------------------------------------------------------------------------------------------
    # | PRE STATE - Request dog list - Test non-existence of elements that should appear/change
    # ------------------------------------------------------------------------------------------
    
    # Verify the dog list is not present before it is requested
    dog_list = driver.find_elements(By.TAG_NAME, "scrollable-list")
    assert len(dog_list) == 0  

    # Verify the dog list items are not present before they are requested
    dog_items = driver.find_elements(By.TAG_NAME, "md-elevated-card")
    assert len(dog_items) == 0     


    # ------------------------------------------------------------------------------------------
    # | STATE CHANGE - Request dog list - Prompt state change
    # ------------------------------------------------------------------------------------------

    request_button.click()

    # ------------------------------------------------------------------------------------------
    # | STATE CHANGE - Request dog list - 
    # | - Expect loading spinner display while waiting for response
    # ------------------------------------------------------------------------------------------

    loading_spinner = WebDriverWait(driver, 10).until(
        EC.visibility_of_element_located((By.ID, "progress-spinner-container"))
    )
    assert loading_spinner.is_displayed()

    # ------------------------------------------------------------------------------------------
    # | STATE CHANGE - Request dog list - Wait for response
    # ------------------------------------------------------------------------------------------

    time.sleep(5)  # Adjust time as needed

    assert not loading_spinner.is_displayed()


    # ------------------------------------------------------------------------------------------
    # | POST STATE - Request dog list - Test display of doglist
    # ------------------------------------------------------------------------------------------

    new_content_outermost_tag = "md-list"

    # Check if the new content is present
    new_content = driver.find_element(By.TAG_NAME, new_content_outermost_tag)  # Replace with the ID of new content
    assert new_content is not None

    
    # Check if the dog list is present in the new content
    dog_list = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.ID, "scrollable-list"))
    )

    # Check if the list is populated with some items, as it should be.
    dog_items = dog_list.find_elements(By.TAG_NAME, "md-elevated-card")
    assert len(dog_items) > 0 


    # ------------------------------------------------------------------------------------------
    # | End the tests - cleanup
    # ------------------------------------------------------------------------------------------

    # Close the browser
    driver.quit()


if __name__ == "__main__":
    test_successful_ops_flow()