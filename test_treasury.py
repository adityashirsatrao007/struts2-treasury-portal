import requests
import json
import sys

BASE_URL = "http://localhost:8080"
SESSION = requests.Session()

def test_register(username, password):
    print(f"--- Registering User: {username} ---")
    payload = {
        "username": username,
        "password": password
    }
    response = SESSION.post(f"{BASE_URL}/register.action", data=payload)
    if response.status_code == 200:
        print("Registration Request Sent (Success redirect to login expected)")
        return True
    return False

def test_login(username, password):
    print(f"--- Attempting Login for {username} ---")
    payload = {
        "username": username,
        "password": password,
        "format": "json"
    }
    response = SESSION.post(f"{BASE_URL}/login.action", data=payload)
    try:
        data = response.json()
        print(f"Response: {data.get('apiMessage')}")
        return data.get('apiSuccess')
    except Exception as e:
        print(f"Error parsing JSON: {e}")
        print(f"Raw Response: {response.text[:200]}")
        return False

def test_get_dashboard():
    print("--- Fetching Treasury Dashboard ---")
    response = SESSION.get(f"{BASE_URL}/treasury.action?format=json")
    try:
        data = response.json()
        print(f"Accounts Found: {len(data.get('accounts', []))}")
        for acc in data.get('accounts', []):
            print(f" - {acc['accountNumber']}: ${acc['balance']}")
        return data
    except Exception as e:
        print(f"Error: {e}")
        return None

def test_initiate_transfer(from_acc, to_acc, amount):
    print(f"--- Initiating Transfer: ${amount} from {from_acc} to {to_acc} ---")
    payload = {
        "fromAccount": from_acc,
        "toAccount": to_acc,
        "amount": amount,
        "format": "json"
    }
    response = SESSION.post(f"{BASE_URL}/initiateTransfer.action", data=payload)
    data = response.json()
    print(f"Response: {data.get('apiMessage')}")
    return data.get('apiSuccess')

def test_approve_transfer(transfer_id):
    print(f"--- Approving Transfer ID: {transfer_id} ---")
    payload = {
        "transferId": transfer_id,
        "format": "json"
    }
    response = SESSION.post(f"{BASE_URL}/approveTransfer.action", data=payload)
    data = response.json()
    print(f"Response: {data.get('apiMessage')}")
    return data.get('apiSuccess')

if __name__ == "__main__":
    # Ensure a fresh user exists
    test_register("admin_test", "password123")
    
    if not test_login("admin_test", "password123"):
        sys.exit(1)
    
    dashboard = test_get_dashboard()
    if not dashboard:
        sys.exit(1)
        
    # Initiate a test transfer
    if test_initiate_transfer("ACC-JPMC-001", "ACC-JPMC-002", 500.0):
        # Re-fetch dashboard to get transfer ID
        dashboard = test_get_dashboard()
        pending = dashboard.get('pendingTransfers', [])
        if pending:
            tid = pending[0]['id']
            test_approve_transfer(tid)
            # Final check
            test_get_dashboard()
        else:
            print("No pending transfers found to approve.")
