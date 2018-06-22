pragma solidity ^0.4.23;

contract LandRegistry {

    struct Point {
        uint id;
        address registrar;
        string latitude;
        string longitude;
    }

    struct Terrain {
        uint id;
        string owner;
        address registrar;
        mapping(uint => Point) polygon;
        uint polygonLength;
    }

    struct TerrainDatabase {
        mapping(uint => Terrain) list;
        uint size;
    }

    TerrainDatabase terrainDatabase;

    constructor() public {
        terrainDatabase = TerrainDatabase({size: 0});
    }

    function createTerrain(string newOwner) 
    public {
        terrainDatabase.size++;
        uint currentId = terrainDatabase.size;
        Terrain memory newTerrain = Terrain({
            id: currentId,
            registrar: msg.sender,
            owner: newOwner,
            polygonLength: 0
        });
        terrainDatabase.list[currentId] = newTerrain;
    }
    
    function addPointToTerrain(uint terrainId, string newLatitude, string newLongitude) 
    public {
        if (terrainId > terrainDatabase.size) revert();

        Terrain storage queriedTerrain = terrainDatabase.list[terrainId];
        queriedTerrain.polygonLength++;
        uint currentId = queriedTerrain.polygonLength;

        Point memory newPoint = Point({
            latitude: newLatitude,
            longitude: newLongitude,
            registrar: msg.sender,
            id: currentId
        });
        queriedTerrain.polygon[currentId] = newPoint;
    }

}