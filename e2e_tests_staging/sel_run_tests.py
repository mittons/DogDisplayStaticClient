import sys
from sel_test_success import *
from sel_test_errors import *

def run_test(test_function):
    print(f"Running {test_function.__name__}...")
    try:
        test_function()
        print(f"{test_function.__name__} completed successfully.\n")
    except Exception as e:
        print(f"Error in {test_function.__name__}: {e}\n")
        return False
    return True

if __name__ == "__main__":
    tests = [
        test_successful_ops_flow,
        test_server_error_on_list_retrieval,
        test_invalid_sig_error_on_list_retrieval,
        test_invalid_sig_error_on_init,
    ]
    
    print()
    print("---==Running Selenium E2E Tests==---")

    results = [run_test(test) for test in tests]
    
    if all(results):
        print("SUCCESS: All tests completed successfully.")
    else:
        failed_tests = results.count(False)
        print(f"FAILURE: {failed_tests} out of {len(tests)} tests failed.")
        sys.exit(1)  # Exit with error code 1 if any tests failed
