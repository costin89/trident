using UnityEngine;

public class TridentOrbitCameraController : MonoBehaviour
{
    public Transform target;
    public Transform elevation;

    public float rotationSpeed = 10.0f; // Geschwindigkeit der Drehung
    public float minXRotation = 0f; // Minimaler Drehwinkel auf der X-Achse
    public float maxXRotation = 85.0f; // Maximaler Drehwinkel auf der X-Achse

    void Update()
    {
        // Drehung um die Y-Achse
        if (Input.GetKey(KeyCode.A))
        {
            target.transform.Rotate(0, -rotationSpeed * Time.deltaTime, 0);
        }
        if (Input.GetKey(KeyCode.D))
        {
            target.transform.Rotate(0, rotationSpeed * Time.deltaTime, 0);
        }

        // Berechne die gewünschte Rotation basierend auf Input
        float desiredRotationX = 0;
        if (Input.GetKey(KeyCode.W))
        {
            desiredRotationX = rotationSpeed * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.S))
        {
            desiredRotationX = -rotationSpeed * Time.deltaTime;
        }

        // Berechne die neue Rotation, ohne sie direkt anzuwenden
        Vector3 newElevationRotation = elevation.transform.eulerAngles + new Vector3(desiredRotationX, 0, 0);
        newElevationRotation.x = (newElevationRotation.x > 180) ? newElevationRotation.x - 360 : newElevationRotation.x; // Normalisiere den Winkelwert

        // Überprüfe die Grenzen und wende die Rotation an, wenn innerhalb der Grenzen
        if (newElevationRotation.x >= minXRotation && newElevationRotation.x <= maxXRotation)
        {
            elevation.transform.Rotate(desiredRotationX, 0, 0);
        }
        else
        {
            // Korrigiere die Rotation, um sie innerhalb der Grenzen zu halten
            float clampedRotationX = Mathf.Clamp(newElevationRotation.x, minXRotation, maxXRotation);
            // Setze die X-Rotation direkt unter Beibehaltung der aktuellen Y- und Z-Rotationen
            elevation.transform.eulerAngles = new Vector3(clampedRotationX, elevation.transform.eulerAngles.y, elevation.transform.eulerAngles.z);
        }
    }
}
