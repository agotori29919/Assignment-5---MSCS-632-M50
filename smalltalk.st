"Base Class: Ride"
Object subclass: #Ride
    instanceVariableNames: 'rideID pickupLocation dropoffLocation distance'
    classVariableNames: ''
    poolDictionaries: ''.

"Initialization Method"
Ride >> initializeWithID: id pickup: pickup dropoff: dropoff distance: dist
    rideID := id.
    pickupLocation := pickup.
    dropoffLocation := dropoff.
    self assertValidDistance: dist.
    distance := dist.

"Validation for Distance"
Ride >> assertValidDistance: dist
    (dist > 0) ifFalse: [self error: 'Distance must be greater than zero.'].

"Abstract Method for Fare Calculation"
Ride >> calculateFare
    self subclassResponsibility.

"Formatted Ride Details"
Ride >> rideDetails
    ^ String streamContents: [:stream |
        stream 
            nextPutAll: 'Ride ID: '; print: rideID;
            nextPutAll: ', Pickup: '; nextPutAll: pickupLocation;
            nextPutAll: ', Dropoff: '; nextPutAll: dropoffLocation;
            nextPutAll: ', Distance: '; print: distance; nextPutAll: ' miles' ].


"StandardRide Class"
Ride subclass: #StandardRide
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''.

"Fare Calculation for Standard Rides"
StandardRide >> calculateFare
    ^ distance * 1.5.

"Override Ride Details for Standard Rides"
StandardRide >> rideDetails
    ^ super rideDetails, ', Fare: $', self calculateFare asString, ' (Standard Rate)'.


"PremiumRide Class"
Ride subclass: #PremiumRide
    instanceVariableNames: ''
    classVariableNames: ''
    poolDictionaries: ''.

"Fare Calculation for Premium Rides"
PremiumRide >> calculateFare
    ^ distance * 3.0.

"Override Ride Details for Premium Rides"
PremiumRide >> rideDetails
    ^ super rideDetails, ', Fare: $', self calculateFare asString, ' (Premium Rate)'.


"Driver Class"
Object subclass: #Driver
    instanceVariableNames: 'driverID name rating assignedRides'
    classVariableNames: ''
    poolDictionaries: ''.

"Initialization Method"
Driver >> initializeWithID: id name: n rating: r
    driverID := id.
    name := n.
    rating := r.
    assignedRides := OrderedCollection new.

"Add a Ride to the Driver's Assigned Rides"
Driver >> addRide: aRide
    assignedRides add: aRide.

"Get Driver Information"
Driver >> getDriverInfo
    ^ String streamContents: [:stream |
        stream 
            nextPutAll: 'Driver ID: '; print: driverID;
            nextPutAll: ', Name: '; nextPutAll: name;
            nextPutAll: ', Rating: '; print: rating;
            nextPutAll: ', Rides Completed: '; print: assignedRides size ].


"Rider Class"
Object subclass: #Rider
    instanceVariableNames: 'riderID name requestedRides'
    classVariableNames: ''
    poolDictionaries: ''.

"Initialization Method"
Rider >> initializeWithID: id name: n
    riderID := id.
    name := n.
    requestedRides := OrderedCollection new.

"Request a Ride"
Rider >> requestRide: aRide
    requestedRides add: aRide.

"View All Requested Rides"
Rider >> viewRides
    ^ requestedRides collect: [:ride | ride rideDetails].


"Factory Method for Creating Rides"
Ride class >> createRide: id pickup: pickup dropoff: dropoff distance: dist type: type
    type = #standard ifTrue: [^ StandardRide new initializeWithID: id pickup: pickup dropoff: dropoff distance: dist].
    type = #premium ifTrue: [^ PremiumRide new initializeWithID: id pickup: pickup dropoff: dropoff distance: dist].
    self error: 'Invalid ride type'.


"Test Cases"
| rider1 driver1 ride1 ride2 |

"Initialize Rider and Driver"
rider1 := Rider new initializeWithID: 1 name: 'Alice'.
driver1 := Driver new initializeWithID: 101 name: 'Bob' rating: 4.8.

"Create Rides Using Factory Method"
ride1 := Ride createRide: 1001 pickup: 'Downtown' dropoff: 'Airport' distance: 10 type: #standard.
ride2 := Ride createRide: 1002 pickup: 'Mall' dropoff: 'Hotel' distance: 5 type: #premium.

"Assign Rides to Rider and Driver"
rider1 requestRide: ride1.
rider1 requestRide: ride2.
driver1 addRide: ride1.
driver1 addRide: ride2.

"Display Driver Information"
Transcript show: driver1 getDriverInfo; cr.

"Display Rider's Ride History"
Transcript show: 'Rider: ', rider1 name, '''s Ride History:'; cr.
Transcript show: (rider1 viewRides joinSeparatedBy: String cr); cr.
