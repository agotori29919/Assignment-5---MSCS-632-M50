#include <iostream>
#include <vector>
#include <memory> // For smart pointers
using namespace std;

// Base Class: Ride
class Ride {
protected:
    int rideID;
    string pickupLocation, dropoffLocation;
    double distance;
public:
    Ride(int id, string pickup, string dropoff, double dist) 
        : rideID(id), pickupLocation(pickup), dropoffLocation(dropoff), distance(dist) {}
    virtual double calculateFare() = 0; // Pure virtual function
    virtual void rideDetails() {
        cout << "Ride ID: " << rideID << "\nPickup: " << pickupLocation 
             << "\nDropoff: " << dropoffLocation << "\nDistance: " << distance << " miles\n";
    }
    virtual ~Ride() {} // Virtual destructor for proper cleanup
};

// Derived Class: StandardRide
class StandardRide : public Ride {
public:
    StandardRide(int id, string pickup, string dropoff, double dist) : Ride(id, pickup, dropoff, dist) {}
    double calculateFare() override {
        return distance * 1.5; // $1.5 per mile
    }
    void rideDetails() override {
        Ride::rideDetails();
        cout << "Fare: $" << calculateFare() << " (Standard Rate)\n";
    }
};

// Derived Class: PremiumRide
class PremiumRide : public Ride {
public:
    PremiumRide(int id, string pickup, string dropoff, double dist) : Ride(id, pickup, dropoff, dist) {}
    double calculateFare() override {
        return distance * 3.0; // $3 per mile
    }
    void rideDetails() override {
        Ride::rideDetails();
        cout << "Fare: $" << calculateFare() << " (Premium Rate)\n";
    }
};

// Driver Class
class Driver {
private:
    vector<unique_ptr<Ride>> assignedRides; // Use smart pointers for automatic memory management
public:
    int driverID;
    string name;
    double rating;
    Driver(int id, string n, double r) : driverID(id), name(n), rating(r) {}
    void addRide(unique_ptr<Ride> ride) {
        assignedRides.push_back(move(ride)); // Move ownership of the pointer
    }
    void getDriverInfo() {
        cout << "Driver ID: " << driverID << "\nName: " << name 
             << "\nRating: " << rating << "\nRides Completed: " << assignedRides.size() << "\n";
    }
};

// Rider Class
class Rider {
public:
    int riderID;
    string name;
    vector<unique_ptr<Ride>> requestedRides; // Use smart pointers for automatic memory management
    Rider(int id, string n) : riderID(id), name(n) {}
    void requestRide(unique_ptr<Ride> ride) {
        requestedRides.push_back(move(ride)); // Move ownership of the pointer
    }
    void viewRides() {
        cout << "Rider: " << name << "'s Ride History:\n";
        for (const auto& ride : requestedRides) {
            ride->rideDetails();
            cout << "-----------------------------\n";
        }
    }
};

// Function to Dynamically Create Rides
unique_ptr<Ride> createRide(int id) {
    string pickup, dropoff;
    double distance;
    int type;

    cout << "Enter Pickup Location: ";
    getline(cin, pickup);
    cout << "Enter Dropoff Location: ";
    getline(cin, dropoff);
    cout << "Enter Distance (in miles): ";
    cin >> distance;
    cin.ignore(); // Clear input buffer

    cout << "Select Ride Type (1 for Standard, 2 for Premium): ";
    cin >> type;
    cin.ignore(); // Clear input buffer

    if (type == 1) {
        return make_unique<StandardRide>(id, pickup, dropoff, distance);
    } else if (type == 2) {
        return make_unique<PremiumRide>(id, pickup, dropoff, distance);
    } else {
        cout << "Invalid Ride Type. Defaulting to Standard Ride.\n";
        return make_unique<StandardRide>(id, pickup, dropoff, distance);
    }
}

// Main Function
int main() {
    Rider rider1(1, "Alice");
    Driver driver1(101, "Bob", 4.8);

    // Dynamically create rides
    cout << "Creating Ride 1:\n";
    unique_ptr<Ride> ride1 = createRide(1001);
    cout << "Creating Ride 2:\n";
    unique_ptr<Ride> ride2 = createRide(1002);

    // Assign rides to rider and driver
    rider1.requestRide(move(ride1));
    rider1.requestRide(move(ride2));
    driver1.addRide(make_unique<StandardRide>(1001, "Downtown", "Airport", 10));
    driver1.addRide(make_unique<PremiumRide>(1002, "Mall", "Hotel", 5));

    // Display driver information
    cout << "\nDriver Information:\n";
    driver1.getDriverInfo();

    // Display rider's ride history
    cout << "\nRide Details:\n";
    rider1.viewRides();

    return 0;
}
